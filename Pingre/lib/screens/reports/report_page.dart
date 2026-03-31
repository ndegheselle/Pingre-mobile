import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/data/value_display.dart';
import 'package:pingre/widgets/inputs/time_range_select.dart';
import 'package:provider/provider.dart';

class _TagTotal {
  final String name;
  final Color color;
  final Decimal total;

  _TagTotal({required this.name, required this.color, required this.total});
}

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  TimeRangeUnit _selectedTimeRange = TimeRangeUnit.month;
  late Future<List<_TagTotal>> _future;
  late TransactionsService _transactions;
  int? _hoveredIndex;

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
    final range = TimeRange.elapsed(_selectedTimeRange);
    final txns = await _transactions.getByRange(range);

    final Map<String, ({String name, Color? tagColor, Decimal total})> groups =
        {};
    for (final txn in txns) {
      final tag = txn.tags.primary;
      final current = groups[tag.id];
      groups[tag.id] = (
        name: tag.name,
        tagColor: tag.color,
        total: (current?.total ?? Decimal.zero) + txn.value.abs(),
      );
    }

    final sorted = groups.values.toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    return sorted.asMap().entries.map((e) {
      final color = e.value.tagColor ?? _palette[e.key % _palette.length];
      return _TagTotal(name: e.value.name, color: color, total: e.value.total);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeRangeSelect(
          value: _selectedTimeRange,
          onChanged: (range) {
            _selectedTimeRange = range;
            _reload();
          },
        ),
        const SizedBox(height: 8),
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
                  Expanded(
                    flex: 5,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 56,
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              setState(() {
                                if (response?.touchedSection != null &&
                                    event.isInterestedForInteractions) {
                                  _hoveredIndex = response!
                                      .touchedSection!
                                      .touchedSectionIndex;
                                } else {
                                  _hoveredIndex = null;
                                }
                              });
                            },
                          ),
                          sections: tagTotals.asMap().entries.map((e) {
                            final isHovered = e.key == _hoveredIndex;
                            return PieChartSectionData(
                              value: e.value.total.toDouble(),
                              color: e.value.color,
                              radius: isHovered ? 72 : 60,
                              showTitle: false,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                      child: FTileGroup(
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
                                color: t.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: Text(t.name),
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
                    SizedBox(height: 4)
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
