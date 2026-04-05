import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/screens/reports/report_filter_sheet.dart';
import 'package:pingre/screens/reports/views/view.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/data/value_display.dart';
import 'package:provider/provider.dart';

class ReportViewAll extends StatefulWidget {
  final TimeRangeUnit rangeUnit;
  final ReportFilters filters;

  const ReportViewAll({super.key, required this.rangeUnit, required this.filters});

  @override
  State<ReportViewAll> createState() => _ReportViewAllState();
}

class _ReportViewAllState extends State<ReportViewAll> {
  late TimeRange _range;
  late Future<List<TagTotal>> _future;
  late TransactionsService _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = context.read<TransactionsService>();
    _range = TimeRange.elapsed(widget.rangeUnit);
    _future = _load();
    _transactions.addListener(_reload);
  }

  @override
  void dispose() {
    _transactions.removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<List<TagTotal>> _load() async {
    final transactions = await _transactions.getByRange(_range);

    final Map<String, TagTotal> groups = {};
    for (var transaction in transactions) {
      if (transaction.value > Decimal.zero &&
          widget.filters.transactionType.contains(TransactionFilter.expenses) ==
              false) {
        continue;
      }
      if (transaction.value < Decimal.zero &&
          widget.filters.transactionType.contains(TransactionFilter.income) == false) {
        continue;
      }
      if (widget.filters.tagIds.isNotEmpty) {
        final transactionTagIds = transaction.tags.all.map((t) => t.id).toSet();
        if (transactionTagIds.intersection(widget.filters.tagIds).isEmpty) continue;
      }

      for (var tag in transaction.tags.all) {
        tag.color = tag.color ?? palette[groups.length % palette.length];
        final current = groups[tag.id];
        groups[tag.id] = TagTotal(
          tag: tag,
          total: (current?.total ?? Decimal.zero) + transaction.value.abs(),
        );
      }
    }

    final sorted = groups.values.toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<TagTotal>>(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: FCircularProgress());
              }
              final tagTotals = snapshot.data!;

              if (tagTotals.isEmpty) {
                return Center(
                  child: Text(
                    'No transactions in this period',
                    style: context.theme.typography.base,
                  ),
                );
              }

              final grandTotal = tagTotals.fold(
                Decimal.zero,
                (sum, t) => sum + t.total,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FCard(
                    style: .delta(
                      contentStyle: .delta(padding: .value(.all(8))),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FButton.icon(
                              variant: .ghost,
                              onPress: () => setState(() {
                                _range = _range.previous();
                                _future = _load();
                              }),
                              child: const Icon(FIcons.chevronLeft),
                            ),
                            const Spacer(),
                            Text(
                              _range.getName(),
                              style: context.theme.typography.base,
                            ),
                            const Spacer(),
                            FButton.icon(
                              variant: .ghost,
                              onPress: _range.isLatest
                                  ? null
                                  : () => setState(() {
                                      _range = _range.next()!;
                                      _future = _load();
                                    }),
                              child: const Icon(FIcons.chevronRight),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        // Graph bar
                        ClipRRect(
                          borderRadius: context.theme.style.borderRadius,
                          child: SizedBox(
                            height: 24,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              spacing: 2,
                              children: tagTotals.map((t) {
                                final pct = grandTotal > Decimal.zero
                                    ? t.total.toDouble() / grandTotal.toDouble()
                                    : 0.0;
                                return Flexible(
                                  flex: (pct * 1000).round(),
                                  child: Container(color: t.tag.color),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ValueDisplay(value: grandTotal, isHeader: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Expanded(
                    child: FTileGroup(
                      divider: .full,
                      children: tagTotals.asMap().entries.map((e) {
                        final t = e.value;

                        return FTile(
                          prefix: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: t.tag.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(t.tag.name),
                          suffix: ValueDisplay(value: t.total),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
