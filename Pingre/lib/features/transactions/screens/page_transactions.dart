import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/common/models/transaction_group.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/widgets/transaction_summary.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/common/widgets/data/elastic_pull_refresh.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/common/widgets/inputs/time_range_select.dart';
import 'package:provider/provider.dart';

class PageTransactions extends StatefulWidget {
  const PageTransactions({super.key});

  @override
  State<PageTransactions> createState() => _PageTransactionsState();
}

class _PageTransactionsState extends State<PageTransactions> {
  TimeRangeUnit _selectedTimeRange = TimeRangeUnit.month;
  late Future<List<Object>> _future;
  late List<TransactionGroup> _groups;
  late TransactionsService _transactions;
  late TimeRange _lastTimeRange;

  late ScrollController _scrollController;
  bool _noMoreTransactions = false;

  @override
  void initState() {
    super.initState();
    _transactions = context.read<TransactionsService>();

    _future = _loadTransactions(_selectedTimeRange);
    _transactions.addListener(_reload);
    _scrollController = ScrollController();
    // _scrollController = ScrollController(initialScrollOffset: 999999);
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
    _noMoreTransactions = false;
    _lastTimeRange = .elapsed(.month);
    // Get a month of transactions
    var transactions = await _transactions.getByRange(_lastTimeRange);

    TransactionGroup firstGroup = TransactionGroup(
      range: .current(unit, end: .now()),
    );

    _groups = [firstGroup];
    _groups.addAll(transactions.continueToGroupFrom(firstGroup));
    return _flatenGroups(_groups);
  }

  Future<List<Object>> _loadPreviousTransactions(TimeRangeUnit unit) async {
    // Load one month worth of transactions
    _lastTimeRange = .elapsed(
      .month,
      end: _lastTimeRange.start.subtract(const Duration(days: 1)),
    );

    var transactions = await _transactions.getByRange(_lastTimeRange);
    var groups = transactions.continueToGroupFrom(_groups.last);
    if (groups.isEmpty) {
      _noMoreTransactions = true;
      return _flatenGroups(_groups);
    }
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
        Expanded(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return FCircularProgress();
              final flatItems = snapshot.data!;

              return CustomScrollView(
                controller:
                    _scrollController, // 👈 this sliver is the scroll anchor (position 0)
                slivers: [
                  // Content grows UPWARD from the anchor
                  SliverList.builder(
                    itemCount: flatItems.length,
                    itemBuilder: (context, index) {
                      final item = flatItems[index];

                      if (item is TransactionGroup) {
                        return Padding(
                          padding: .symmetric(vertical: 4),
                          child: Column(
                            children: [
                              FTile(
                                style: .delta(
                                  contentStyle: .delta(
                                    padding: .value(.all(8)),
                                  ),
                                ),
                                prefix: const Icon(FIcons.calendar),
                                title: Text(item.name),
                                suffix: ValueDisplay(
                                  value: item.total,
                                  isHeader: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (item is Transaction) {
                        final isLast =
                            index ==
                                1 || // 👈 was: index == flatItems.length - 1
                            flatItems[flatItems.length - index - 1]
                                is TransactionGroup;
                        return Column(
                          children: [
                            TransactionSummary(transaction: item),
                            if (isLast) SizedBox(height: 4),
                          ],
                        );
                      }

                      return SizedBox.shrink();
                    },
                  ),
                  // Footer sits AT the anchor point (visually at the bottom)
                  if (!_noMoreTransactions)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElasticPullToRefresh(
                          onRefresh: _loadMore,
                          onDrag: () => _scrollController.jumpTo(
                            _scrollController.position.maxScrollExtent,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
