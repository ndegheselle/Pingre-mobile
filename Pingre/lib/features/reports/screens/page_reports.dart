import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/reports/models/report_filters.dart';
import 'package:pingre/features/reports/models/tag_total.dart';
import 'package:pingre/features/reports/screens/overlay_report_filters.dart';
import 'package:pingre/features/reports/screens/overlay_tag_detail.dart';
import 'package:pingre/features/reports/services/csv_export.dart';
import 'package:pingre/features/reports/widgets/tag_graph_bar.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/common/widgets/inputs/time_range_select.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

enum _ReportView { primary, all }

class PageReports extends StatefulWidget {
  const PageReports({super.key});

  @override
  State<PageReports> createState() => _PageReportsState();
}

class _PageReportsState extends State<PageReports> {
  late TimeRange _range;
  late Future<List<TagTotal>> _future;
  late TransactionsService _transactions;

  TimeRangeUnit _selectedTimeRange = TimeRangeUnit.month;
  ReportFilters _filters = const ReportFilters();
  _ReportView _selectedView = _ReportView.primary;

  @override
  void initState() {
    super.initState();
    _transactions = context.read<TransactionsService>();
    _range = .current(_selectedTimeRange);
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

  Future<List<TagTotal>> _load() {
    return _selectedView == _ReportView.primary ? _loadPrimary() : _loadAll();
  }

  Future<List<TagTotal>> _loadPrimary() async {
    final transactions = await _transactions.getByRange(_range);

    final Map<String, TagTotal> groups = {};
    for (var transaction in transactions) {
      if (transaction.value < Decimal.zero &&
          _filters.transactionType.contains(TransactionFilter.expenses) == false) {
        continue;
      }
      if (transaction.value > Decimal.zero &&
          _filters.transactionType.contains(TransactionFilter.income) == false) {
        continue;
      }
      if (_filters.tagIds.isNotEmpty) {
        final transactionTagIds = transaction.tags.all.map((t) => t.id).toSet();
        if (transactionTagIds.intersection(_filters.tagIds).isEmpty) continue;
      }
      final tag = transaction.tags.primary;
      tag.color = tag.color ?? palette[groups.length % palette.length];
      final current = groups[tag.id];
      groups[tag.id] = TagTotal(
        tag: tag,
        total: (current?.total ?? Decimal.zero) + transaction.value,
      );
    }

    final sorted = groups.values.toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    final grandTotal = sorted.fold(Decimal.zero, (sum, t) => sum + t.total);
    return sorted.map((t) => TagTotal(
      tag: t.tag,
      total: t.total,
      percent: grandTotal != Decimal.zero
          ? t.total.abs().toDouble() / grandTotal.abs().toDouble() * 100
          : 0.0,
    )).toList();
  }

  Future<List<TagTotal>> _loadAll() async {
    final transactions = await _transactions.getByRange(_range);

    final Map<String, TagTotal> groups = {};
    for (var transaction in transactions) {
      if (transaction.value > Decimal.zero &&
          _filters.transactionType.contains(TransactionFilter.expenses) == false) {
        continue;
      }
      if (transaction.value < Decimal.zero &&
          _filters.transactionType.contains(TransactionFilter.income) == false) {
        continue;
      }
      if (_filters.tagIds.isNotEmpty) {
        final transactionTagIds = transaction.tags.all.map((t) => t.id).toSet();
        if (transactionTagIds.intersection(_filters.tagIds).isEmpty) continue;
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

  Future<void> _openFilterSheet() async {
    final result = await showReportFilterSheet(context, current: _filters);
    if (result != null) {
      setState(() {
        _filters = result;
        _future = _load();
      });
    }
  }

  Future<void> _exportCsv() async {
    final l10n = AppLocalizations.of(context)!;
    final transactions = await _transactions.getByRange(_range);

    final filtered = transactions.where((t) {
      if (t.value < Decimal.zero &&
          !_filters.transactionType.contains(TransactionFilter.expenses)) {
        return false;
      }
      if (t.value > Decimal.zero &&
          !_filters.transactionType.contains(TransactionFilter.income)) {
        return false;
      }
      if (_filters.tagIds.isNotEmpty) {
        final tagIds = t.tags.all.map((tag) => tag.id).toSet();
        if (tagIds.intersection(_filters.tagIds).isEmpty) return false;
      }
      return true;
    }).toList();

    final buffer = StringBuffer();
    buffer.writeln('date,value,primary_tag,tags,notes');
    for (final t in filtered) {
      final date =
          '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}';
      final value = t.value.toString();
      final primaryTag = _escapeCsv(t.tags.primary.name);
      final allTags = _escapeCsv(t.tags.all.map((tag) => tag.name).join(';'));
      final notes = _escapeCsv(t.notes);
      buffer.writeln('$date,$value,$primaryTag,$allTags,$notes');
    }

    final today = DateTime.now();
    final filename =
        'transactions_${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}.csv';
    final bytes = utf8.encode(buffer.toString());
    final path = await saveCsvFile(bytes, filename);

    if (!mounted) return;
    showFToast(
      context: context,
      alignment: .topCenter,
      icon: const Icon(FIcons.fileUp),
      title: Text(l10n.reportExportSuccess),
      description: path != null ? Text(path) : Text(l10n.reportExportDownloaded),
    );
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        TimeRangeSelect(
          value: _selectedTimeRange,
          onChanged: (unit) {
            setState(() {
              _selectedTimeRange = unit;
              _range = .current(unit);
              _future = _load();
            });
          },
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: FSelectMenuTile<_ReportView>(
                style: .delta(menuStyle: .delta(maxWidth: 300)),
                selectControl: .managedRadio(
                  initial: .primary,
                  onChange: (values) {
                    if (values.isNotEmpty) {
                      setState(() {
                        _selectedView = values.first;
                        _future = _load();
                      });
                    }
                  },
                ),
                prefix: const Icon(FIcons.squareChartGantt),
                title: Text(l10n.reportView),
                detailsBuilder: (context, values, child) => Text(
                  values
                      .map((v) => switch (v) {
                            _ReportView.primary => l10n.reportViewPrimary,
                            _ReportView.all => l10n.reportViewAll,
                          })
                      .join(', '),
                ),
                menu: [
                  .suffix(
                    prefix: const Icon(FIcons.listTree),
                    title: Text(l10n.reportViewPrimary),
                    subtitle: Text(l10n.reportViewPrimaryDesc),
                    value: .primary,
                  ),
                  .suffix(
                    prefix: const Icon(FIcons.list),
                    title: Text(l10n.reportViewAll),
                    subtitle: Text(l10n.reportViewAllDesc),
                    value: .all,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            FTooltip(
              tipBuilder: (context, _) => Text(l10n.reportFiltersTooltip),
              child: FButton.icon(
                size: .lg,
                variant: .outline,
                onPress: _openFilterSheet,
                child: const Icon(FIcons.funnel),
              ),
            ),
            const SizedBox(width: 4),
            FTooltip(
              tipBuilder: (context, _) => Text(l10n.reportExportTooltip),
              child: FButton.icon(
                size: .lg,
                variant: .outline,
                onPress: _exportCsv,
                child: const Icon(FIcons.fileUp),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: FutureBuilder<List<TagTotal>>(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: FCircularProgress());
              }
              final tagTotals = snapshot.data!;

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
                              _range.getName(Localizations.localeOf(context).languageCode),
                              style: context.theme.typography.base,
                            ),
                            const Spacer(),
                            FButton.icon(
                              variant: .ghost,
                              onPress: () => setState(() {
                                _range = _range.next();
                                _future = _load();
                              }),
                              child: const Icon(FIcons.chevronRight),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        TagGraphBar(
                          tagTotals: tagTotals,
                          grandTotal: grandTotal,
                        ),
                        const SizedBox(height: 4),
                        ValueDisplay(value: grandTotal, isHeader: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  tagTotals.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              l10n.reportNoTransactions,
                              style: context.theme.typography.base,
                            ),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: .only(bottom: 4),
                            child: FTileGroup(
                              divider: .full,
                              children: tagTotals.map((t) {
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
                                  subtitle: t.percent != null
                                      ? Text('${t.percent!.toStringAsFixed(1)}%')
                                      : null,
                                  suffix: ValueDisplay(value: t.total),
                                  onPress: () => showTagDetail(
                                    context,
                                    tag: t.tag,
                                    range: _range,
                                  ),
                                );
                              }).toList(),
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
