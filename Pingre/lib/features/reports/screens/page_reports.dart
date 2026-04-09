import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/reports/models/report_filters.dart';
import 'package:pingre/features/reports/screens/overlay_report_filters.dart';
import 'package:pingre/features/reports/screens/views/view_primary.dart';
import 'package:pingre/common/widgets/inputs/time_range_select.dart';

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
                title: const Text('View'),
                detailsBuilder: (context, values, child) => Text(
                  values
                      .map(
                        (v) => switch (v) {
                          _ReportView.primary => 'Primary',
                          _ReportView.all => 'All',
                        },
                      )
                      .join(', '),
                ),
                menu: const [
                  .suffix(
                    prefix: Icon(FIcons.listTree),
                    title: Text("Primary"),
                    subtitle: Text("Grouup by primary tag"),
                    value: .primary,
                  ),
                  .suffix(
                    prefix: Icon(FIcons.list),
                    title: Text("All"),
                    subtitle: Text("Group by tag (with duplicates)"),
                    value: .all,
                  ),
                ],
              ),
            ),
            SizedBox(width: 4),
            FTooltip(
              tipBuilder: (context, _) => const Text('Filters'),
              child: FButton.icon(
                size: .lg,
                variant: .outline,
                onPress: _openFilterSheet,
                child: Icon(FIcons.funnel),
              ),
            ),
            SizedBox(width: 4),
            FTooltip(
              tipBuilder: (context, _) => const Text('Export'),
              child: FButton.icon(
                size: .lg,
                variant: .outline,
                onPress: null,
                child: Icon(FIcons.fileUp),
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
