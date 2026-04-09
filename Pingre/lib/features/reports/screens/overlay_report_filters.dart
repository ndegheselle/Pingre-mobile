import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/reports/models/report_filters.dart';
import 'package:pingre/features/tags/screens/overlay_tags_select.dart';
import 'package:pingre/common/widgets/layout/sheet_container.dart';

Future<ReportFilters?> showReportFilterSheet(
  BuildContext context, {
  required ReportFilters current,
}) {
  return showFSheet<ReportFilters>(
    mainAxisMaxRatio: 7 / 10,
    context: context,
    side: .btt,
    builder: (context) => OverlayReportFilters(current: current),
  );
}

class OverlayReportFilters extends StatefulWidget {
  final ReportFilters current;

  const OverlayReportFilters({super.key, required this.current});

  @override
  State<OverlayReportFilters> createState() => _OverlayReportFiltersState();
}

class _OverlayReportFiltersState extends State<OverlayReportFilters> {
  late Set<TransactionFilter> _transactionType;
  late Set<String> _selectedTagIds;

  final TextEditingController _tagSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transactionType = Set.from(widget.current.transactionType);
    _selectedTagIds = Set.from(widget.current.tagIds);
  }

  void _toggleTag(String id) {
    setState(() {
      if (_selectedTagIds.contains(id)) {
        _selectedTagIds.remove(id);
      } else {
        _selectedTagIds.add(id);
      }
    });
  }

  void _apply() {
    Navigator.of(context).pop(
      ReportFilters(
        transactionType: _transactionType,
        tagIds: Set.from(_selectedTagIds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      title: "Filters",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            "Transaction type",
            style: context.theme.typography.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 4),
          FSelectMenuTile<TransactionFilter>(
            selectControl: .managed(
              initial: _transactionType,
              onChange: (values) {
                setState(() {
                  _transactionType = values;
                });
              },
            ),
            detailsBuilder: (context, values, child) => Text(
              values.map((v) => switch (v) {
                TransactionFilter.expenses => 'Expenses',
                TransactionFilter.income => 'Income',
              }).join(', '),
            ),
            prefix: const Icon(FIcons.banknote),
            title: const Text('Transaction Type'),
            menu: const [
              .suffix(
                prefix: Icon(FIcons.trendingDown),
                title: Text('Expenses'),
                value: .expenses,
              ),
              .suffix(
                prefix: Icon(FIcons.trendingUp),
                title: Text('Income'),
                value: .income,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Tags",
            style: context.theme.typography.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 4),
          FTextField(
            control: .managed(controller: _tagSearchController),
            prefixBuilder: (context, style, variants) => Padding(
              padding: .directional(start: 8),
              child: Opacity(opacity: 0.5, child: Icon(FIcons.search)),
            ),
            hint: 'Search tags ...',
            clearable: (value) => value.text.isNotEmpty,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _tagSearchController,
              builder: (context, _, _) => TagsWrap(
                primaryTagId: null,
                secondariesIds: _selectedTagIds,
                search: _tagSearchController.text.trim(),
                onTap: _toggleTag,
                onLongPress: (_) {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          FButton(
            onPress: _apply,
            prefix: const Icon(FIcons.check),
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}
