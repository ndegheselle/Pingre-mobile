import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/reports/models/report_filters.dart';
import 'package:pingre/features/reports/screens/overlay_report_filters.dart';
import 'package:pingre/features/reports/screens/views/view_primary.dart';
import 'package:pingre/common/widgets/inputs/time_range_select.dart';
import 'package:pingre/l10n/app_localizations.dart';

enum _ReportView { primary, all }

class PageReports extends StatefulWidget {
  const PageReports({super.key});

  @override
  State<PageReports> createState() => _PageReportsState();
}

class _PageReportsState extends State<PageReports> {
  TimeRangeUnit _selectedTimeRange = TimeRangeUnit.month;
  ReportFilters _filters = const ReportFilters();

  Future<void> _openFilterSheet() async {
    final result = await showReportFilterSheet(context, current: _filters);
    if (result != null) {
      setState(() {
        _filters = result;
      });
    }
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
                  onChange: (values) {},
                ),
                prefix: const Icon(FIcons.squareChartGantt),
                title: Text(l10n.reportView),
                detailsBuilder: (context, values, child) => Text(
                  values
                      .map(
                        (v) => switch (v) {
                          _ReportView.primary => l10n.reportViewPrimary,
                          _ReportView.all => l10n.reportViewAll,
                        },
                      )
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
                onPress: null,
                child: const Icon(FIcons.fileUp),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ReportViewPrimary(
            rangeUnit: _selectedTimeRange,
            filters: _filters,
          ),
        ),
      ],
    );
  }
}
