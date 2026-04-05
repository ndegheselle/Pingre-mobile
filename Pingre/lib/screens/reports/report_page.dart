import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/screens/reports/report_filter_sheet.dart';
import 'package:pingre/screens/reports/views/view_primary.dart';
import 'package:pingre/widgets/inputs/time_range_select.dart';

enum _ReportView { primary, all }

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
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
            _selectedTimeRange = unit;
          },
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: FSelectMenuTile<_ReportView>(
                style: .delta(menuStyle: .delta(maxWidth: 300)),
                selectControl: .managedRadio(onChange: (values) {}),
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
                    subtitle: Text(
                      "Grouup by primary tag",
                    ),
                    value: .primary,
                  ),
                  .suffix(
                    prefix: Icon(FIcons.list),
                    title: Text("All"),
                    subtitle: Text(
                      "Group by tag (with duplicates)",
                    ),
                    value: .all,
                  ),
                ],
              ),
            ),
            SizedBox(width: 4),
            FButton.icon(
                size: .lg,
              variant: .secondary,
              onPress: _openFilterSheet,
              child: Icon(FIcons.funnel),
            ),
            SizedBox(width: 4),
            FButton.icon(
                size: .lg,
              variant: .secondary,
              onPress: null,
              child: Icon(FIcons.fileUp),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(child: 
        ReportViewPrimary(rangeUnit: _selectedTimeRange, filters: _filters))
     ],
    );
  }
}
