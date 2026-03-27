import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/models/transaction_group.dart';
import 'package:pingre/screens/transactions/edit/transaction_edit.dart';
import 'package:pingre/screens/transactions/value_display.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/elastic_pull_refresh.dart';
import 'package:pingre/widgets/time_range_select.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionssPageState();
}

class _TransactionssPageState extends State<TransactionsPage> {
  TimeRangeUnit _selectedTimeRange = TimeRangeUnit.month;
  late Future<List<Object>> _future;
  late List<TransactionGroup> _groups;
  late TransactionsService _transactions;
  late TimeRange _lastTimeRange;
  late ScrollController _scrollController;

  bool _lockScroll = false;

  @override
  void initState() {
    super.initState();
    _transactions = context.read<TransactionsService>();
    _future = _loadTransactions(_selectedTimeRange);

    _transactions.addListener(_reload);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _transactions.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = _loadTransactions(_selectedTimeRange);
    });
  }

  void _loadMore() {
    setState(() {
      _future = _loadPreviousTransactions(_selectedTimeRange);
    });
  }

  /// Load transactions, reset the current [_groups] if previous transactions where manually loaded by the user.
  Future<List<Object>> _loadTransactions(TimeRangeUnit unit) async {
    _lastTimeRange = .elapsed(.month);
    // Get a month of transactions
    var transactions = await _transactions.getByRange(_lastTimeRange);
    _groups = transactions.groupByUnit(unit);
    return _flatenGroups(_groups);
  }

  Future<List<Object>> _loadPreviousTransactions(TimeRangeUnit unit) async {
    _lastTimeRange = .elapsed(.month, _lastTimeRange.start);
    // Get a month of transactions
    var transactions = await _transactions.getByRange(_lastTimeRange);
    var groups = transactions.continueToGroupFrom(_groups.last);
    _groups.addAll(groups);
    return _flatenGroups(_groups);
  }

  List<Object> _flatenGroups(List<TransactionGroup> groups) {
    List<Object> flatItems = [];
    for (final group in groups) {
      flatItems.add(group); // header
      flatItems.addAll(group.transactions); // individual rows
    }
    return flatItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TimeRangeSelect(
          value: _selectedTimeRange,
          onChanged: (range) {
            _selectedTimeRange = range;
            _reload();
          },
        ),
        SizedBox(height: 4),
        Expanded(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return FCircularProgress();
              final flatItems = snapshot.data!;

              return ListView.builder(
                controller: _scrollController,
                itemCount: flatItems.length + 1,
                reverse: true,
                itemBuilder: (context, index) {
                  // Footer case
                  if (index == 0) {
                    return ElasticPullToRefresh(
                      onRefresh: _loadMore,
                    );
                  }

                  final item = flatItems[flatItems.length - index];

                  if (item is TransactionGroup) {
                    return Column(
                      children: [
                        FTile(
                          style: .delta(
                            contentStyle: .delta(padding: .value(.all(8))),
                          ),
                          prefix: const Icon(FIcons.calendar),
                          title: Text(item.name),
                          suffix: ValueDisplay(
                            value: item.total,
                            isHeader: true,
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    );
                  }

                  if (item is Transaction) {
                    final isLast =
                        index == 1 || // 👈 was: index == flatItems.length - 1
                        flatItems[flatItems.length - index - 1]
                            is TransactionGroup;
                    return Column(
                      children: [
                        FItem(
                          style: .delta(margin: .value(.all(0))),
                          title: Text(item.tags.primary.name),
                          subtitle: item.tags.secondaries.isEmpty
                              ? null
                              : Text(
                                  item.tags.secondaries
                                      .map((t) => t.name)
                                      .join(", "),
                                ),
                          suffix: ValueDisplay(value: item.value),
                          onPress: () =>
                              showTransactionEdit(context, transaction: item),
                        ),
                        if (isLast) SizedBox(height: 4),
                      ],
                    );
                  }

                  return SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
