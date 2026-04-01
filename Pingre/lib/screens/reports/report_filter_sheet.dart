import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/widgets/layout/sheet_container.dart';
import 'package:provider/provider.dart';

enum TransactionFilter { expenses, both, income }

class ReportFilter {
  final TransactionFilter transactionType;
  final Set<String> tagIds;

  const ReportFilter({
    this.transactionType = TransactionFilter.both,
    this.tagIds = const {},
  });

  bool get isActive =>
      transactionType != TransactionFilter.both || tagIds.isNotEmpty;

  ReportFilter copyWith({
    TransactionFilter? transactionType,
    Set<String>? tagIds,
  }) {
    return ReportFilter(
      transactionType: transactionType ?? this.transactionType,
      tagIds: tagIds ?? this.tagIds,
    );
  }
}

Future<ReportFilter?> showReportFilterSheet(
  BuildContext context, {
  required ReportFilter current,
}) {
  return showFSheet<ReportFilter>(
    mainAxisMaxRatio: 7 / 10,
    context: context,
    side: .btt,
    builder: (context) => ReportFilterSheet(current: current),
  );
}

class ReportFilterSheet extends StatefulWidget {
  final ReportFilter current;

  const ReportFilterSheet({super.key, required this.current});

  @override
  State<ReportFilterSheet> createState() => _ReportFilterSheetState();
}

class _ReportFilterSheetState extends State<ReportFilterSheet> {
  late TransactionFilter _transactionType;
  late Set<String> _selectedTagIds;

  @override
  void initState() {
    super.initState();
    _transactionType = widget.current.transactionType;
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
      ReportFilter(
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
          SegmentedButton<TransactionFilter>(
            segments: const [
              ButtonSegment(
                value: TransactionFilter.expenses,
                label: Text('Expenses'),
              ),
              ButtonSegment(
                value: TransactionFilter.both,
                label: Text('Both'),
              ),
              ButtonSegment(
                value: TransactionFilter.income,
                label: Text('Income'),
              ),
            ],
            selected: {_transactionType},
            onSelectionChanged: (selection) {
              setState(() => _transactionType = selection.first);
            },
          ),
          const SizedBox(height: 12),
          Text(
            "Tags",
            style: context.theme.typography.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<TagsService>(
                builder: (context, service, _) {
                  if (service.tags.isEmpty) {
                    return Opacity(
                      opacity: 0.5,
                      child: Text(
                        "No tags",
                        style: context.theme.typography.base,
                      ),
                    );
                  }

                  final tags = service.tags.toList()
                    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                  return Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: tags.map((tag) {
                      final isSelected = _selectedTagIds.contains(tag.id);
                      return GestureDetector(
                        onTap: () => _toggleTag(tag.id),
                        child: FBadge(
                          style: .delta(
                            contentStyle: .delta(
                              labelTextStyle: .delta(
                                fontSize:
                                    context.theme.typography.lg.fontSize,
                              ),
                            ),
                          ),
                          variant: isSelected ? .android : .outline,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                Icon(
                                  FIcons.check,
                                  color: context.theme.colors.background,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(tag.name),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
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
