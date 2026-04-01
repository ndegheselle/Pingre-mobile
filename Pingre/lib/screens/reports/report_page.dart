import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/screens/reports/report_filter_sheet.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/data/value_display.dart';
import 'package:pingre/widgets/inputs/time_range_select.dart';
import 'package:provider/provider.dart';

class _TagTotal {
  final Tag tag;
  final Decimal total;

  _TagTotal({required this.tag, required this.total});
}

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  TimeRangeUnit _selectedTimeRange = TimeRangeUnit.month;
  late TimeRange _range;
  late Future<List<_TagTotal>> _future;
  late TransactionsService _transactions;
  int? _hoveredIndex;
  final ScrollController _scrollController = ScrollController();
  ReportFilter _filter = const ReportFilter();

  static const List<Color> _palette = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFFF97316),
    Color(0xFF14B8A6),
    Color(0xFF06B6D4),
    Color(0xFF84CC16),
    Color(0xFFEAB308),
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
  ];

  @override
  void initState() {
    super.initState();
    _transactions = context.read<TransactionsService>();
    _range = TimeRange.elapsed(_selectedTimeRange);
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

  Future<List<_TagTotal>> _load() async {
    final transactions = await _transactions.getByRange(_range);

    final Map<String, _TagTotal> groups = {};
    for (var transaction in transactions) {
      if (_filter.transactionType == TransactionFilter.expenses &&
          transaction.value > Decimal.zero)
        continue;
      if (_filter.transactionType == TransactionFilter.income &&
          transaction.value < Decimal.zero)
        continue;
      if (_filter.tagIds.isNotEmpty) {
        final transactionTagIds =
            transaction.tags.all.map((t) => t.id).toSet();
        if (transactionTagIds.intersection(_filter.tagIds).isEmpty) continue;
      }
      final tag = transaction.tags.primary;
      tag.color = tag.color ?? _palette[groups.length % _palette.length];
      final current = groups[tag.id];
      groups[tag.id] = _TagTotal(
        tag: tag,
        total: (current?.total ?? Decimal.zero) + transaction.value.abs(),
      );
    }

    final sorted = groups.values.toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    return sorted;
  }

  Future<void> _openFilterSheet() async {
    final result = await showReportFilterSheet(
      context,
      current: _filter,
    );
    if (result != null) {
      setState(() {
        _filter = result;
        _future = _load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TimeRangeSelect(
                value: _selectedTimeRange,
                onChanged: (unit) {
                  _selectedTimeRange = unit;
                  _range = TimeRange.elapsed(unit);
                  _reload();
                },
              ),
            ),
            FButton(
              variant: _filter.isActive ? .primary : .ghost,
              onPress: _openFilterSheet,
              child: Icon(FIcons.slidersHorizontal),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: FutureBuilder<List<_TagTotal>>(
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
                      scrollController: _scrollController,
                      divider: .full,
                      children: tagTotals.asMap().entries.map((e) {
                        final index = e.key;
                        final t = e.value;
                        final pct = grandTotal > Decimal.zero
                            ? t.total.toDouble() / grandTotal.toDouble() * 100
                            : 0.0;

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
                          subtitle: Text('${pct.toStringAsFixed(1)}%'),
                          suffix: ValueDisplay(value: t.total),
                          onPress: () {
                            setState(() {
                              _hoveredIndex = _hoveredIndex == index
                                  ? null
                                  : index;
                            });
                          },
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
