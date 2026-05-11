import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/common/models/transaction_group.dart';
import 'package:pingre/common/widgets/data/elastic_pull_refresh.dart';
import 'package:pingre/common/widgets/inputs/time_range_select.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/features/transactions/widgets/group_summary.dart';
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
  TransactionGroup? _currentGroup;

  late ScrollController _scrollController;

  static const double transactionHeight = 38;
  static const double groupHeight = 42;

  @override
  void initState() {
    super.initState();
    _transactions = context.read<TransactionsService>();

    _future = _loadTransactions(_selectedTimeRange);
    _transactions.addListener(_reload);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _transactions.removeListener(_reload);
    _transactions.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    var currentOffest = 0.0;
    for (var group in _groups) {
      currentOffest +=
          groupHeight + group.transactions.length * transactionHeight;
      if (currentOffest > offset) {
        setState(() {
          _currentGroup = group;
        });
        break;
      }
    }
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

    _currentGroup = firstGroup;
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
      if (mounted) {
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
    bool firstGroup = true;

    for (final group in groups) {
      if (firstGroup) {
        firstGroup = false;
      } else {
        flatItems.add(group);
      }

      flatItems.addAll(group.transactions); // individual rows
    }
    return flatItems;
  }

  @override
  Widget build(BuildContext context) {
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
        if (_currentGroup != null)
          GroupSummary(group: _currentGroup!, height: groupHeight),
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
                      final next = index + 1 < flatItems.length
                          ? flatItems[index + 1]
                          : null;

                      if (item is TransactionGroup) {
                        return GroupSummary(group: item, height: groupHeight);
                      }

                      if (item is Transaction) {
                        return SizedBox(
                          height: transactionHeight,
                          child: Column(
                            mainAxisAlignment: .start,
                            children: [
                              TransactionSummary(transaction: item),
                              if (next is Transaction)
                                FDivider(
                                  style: .delta(
                                    padding: .value(.symmetric(horizontal: 10)),
                                    width: context.theme.style.borderWidth,
                                  ),
                                  axis: .horizontal,
                                ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
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
