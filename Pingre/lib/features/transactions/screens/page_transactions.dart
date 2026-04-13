import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/common/models/transaction_group.dart';
import 'package:pingre/common/widgets/data/elastic_pull_refresh.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/common/widgets/inputs/time_range_select.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/features/transactions/widgets/transaction_summary.dart';
import 'package:pingre/l10n/app_localizations.dart';
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
    if (transactions.isEmpty) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        showFToast(
          context: context,
          alignment: .topCenter,
          icon: const Icon(FIcons.check),
          title: Text(l10n.transactionDetailTitle),
          description: Text(l10n.transactionNoMoreFound),
        );
      }
      return _flatenGroups(_groups);
    }

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
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

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

              final hasTransactions = flatItems.any(
                (item) => item is Transaction,
              );

              if (!hasTransactions) {
                return Center(child: Text(l10n.reportNoTransactions));
              }

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList.builder(
                    itemCount: flatItems.length,
                    itemBuilder: (context, index) {
                      final item = flatItems[index];

                      if (item is TransactionGroup) {
                        return Padding(
                          padding: .only(top: 4),
                          child: FTile(
                            style: .delta(
                              contentStyle: .delta(padding: .value(.all(8))),
                            ),
                            prefix: const Icon(FIcons.calendar),
                            title: Text(item.getName(locale)),
                            suffix: ValueDisplay(
                              value: item.total,
                              isHeader: true,
                            ),
                          ),
                        );
                      }

                      if (item is Transaction) {
                        return Padding(
                          padding: .only(top: 4),
                          child: TransactionSummary(transaction: item),
                        );
                      }
                    },
                  ),
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
