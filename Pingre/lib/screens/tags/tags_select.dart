import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/inputs/search_add.dart';
import 'package:pingre/widgets/layout/sheet_container.dart';
import 'package:provider/provider.dart';

Future<TagsSelection?> showTagsSelect(
  BuildContext context, {
  TagsSelection? initialSelection,
}) {
  return showFSheet<TagsSelection>(
    mainAxisMaxRatio: 6 / 10,
    context: context,
    side: .btt,
    builder: (context) => TagsSelect(initialSelection: initialSelection),
  );
}

class TagsSelect extends StatefulWidget {
  final TagsSelection? initialSelection;

  const TagsSelect({super.key, this.initialSelection});

  @override
  State<TagsSelect> createState() => _TagsSelectState();
}

class _TagsSelectState extends State<TagsSelect> {
  late String? _primaryTagId;
  late Set<String> _secondariesIds;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _primaryTagId = widget.initialSelection?.primary.id;
    _secondariesIds =
        widget.initialSelection?.secondaries.map((t) => t.id).toSet() ?? {};
  }

  void _toggleTag(String id) {
    setState(() {
      // If selected
      if (id == _primaryTagId) {
        _primaryTagId = null;
        if (_secondariesIds.isEmpty == false) _primaryTagId = _secondariesIds.first;
      }
      else if (_secondariesIds.contains(id)) {
        _secondariesIds.remove(id);
      }
      else if (_primaryTagId == null) {
        _primaryTagId = id;
      } else {
        _secondariesIds.add(id);
      }
    });
  }

  void _setPrimaryTag(String id) {
    if (_primaryTagId == id) return;
    if (_secondariesIds.contains(id)) _secondariesIds.remove(id);
    setState(() {
      if (_primaryTagId != null) _secondariesIds.add(_primaryTagId!);
      _primaryTagId = id;
    });
  }

  void _addTag(String name) {
    var tag = context.read<TagsService>().getOrCreate(name);
    _toggleTag(tag.id);
  }

  void _confirm() {
    if (_primaryTagId == null) return Navigator.of(context).pop();

    var service = context.read<TagsService>();
    var secondaries = _secondariesIds
        .map((id) => service.tagsMap[id]!)
        .toList();
    return Navigator.of(
      context,
    ).pop(TagsSelection(primary: service.tagsMap[_primaryTagId]!, secondaries: secondaries));
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      title: "Select tags",
      child: Column(
        children: [
          const SizedBox(height: 4),
          SearchWithAdd(controller: _controller, onAdd: _addTag, hint: "Tag name ...", alwaysShowAdd: false),
          const SizedBox(height: 4),
          Center(child: Opacity(opacity: 0.5, child: Text("Long press to set primary tag", style: context.theme.typography.sm))),
          const SizedBox(height: 4),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: _controller,
                  builder: (context, _, _) {
                    return TagsWrap(
                      primaryTagId: _primaryTagId,
                      secondariesIds: _secondariesIds,
                      search: _controller.text.trim(),
                      onTap: _toggleTag,
                      onLongPress: _setPrimaryTag,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FButton(
            onPress: _confirm,
            prefix: const Icon(FIcons.check),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}

class TagsWrap extends StatelessWidget {
  final String? primaryTagId;
  final Set<String> secondariesIds;
  final String search;
  final void Function(String id) onTap;
  final void Function(String id) onLongPress;

  const TagsWrap({
    super.key,
    required this.primaryTagId,
    required this.secondariesIds,
    required this.search,
    required this.onTap,
    required this.onLongPress,
  });

  bool _isSelected(String id) {
    if (id == primaryTagId) return true;
    return secondariesIds.contains(id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TagsService>(
      builder: (context, service, child) {
        if (service.tags.isEmpty) {
          return const Center(
            child: Opacity(
              opacity: 0.5,
              child: Text("No existing tag"),
            ),
          );
        }

        final filtered =
            (search.isEmpty ? service.tags : service.search(search)).toList();

        filtered.sort((a, b) {
          if (a.id == primaryTagId) return -1;
          if (b.id == primaryTagId) return 1;

          final aSelected = secondariesIds.contains(a.id);
          final bSelected = secondariesIds.contains(b.id);

          if (aSelected != bSelected) return aSelected ? -1 : 1;

          return b.updatedAt.compareTo(a.updatedAt); // newest first
        });

        return Wrap(
          alignment: WrapAlignment.start,
          spacing: 4,
          runSpacing: 4,
          children: filtered.map((tag) {
            final isSelected = _isSelected(tag.id);
            final isPrimary = tag.id == primaryTagId;
            return GestureDetector(
              onLongPress: () => onLongPress(tag.id),
              onTap: () => onTap(tag.id),
              child: FBadge(
                style: .delta(
                  contentStyle: .delta(
                    labelTextStyle: .delta(
                      fontSize: context.theme.typography.lg.fontSize,
                    ),
                  ),
                ),
                variant: isSelected
                    ? (isPrimary ? .android : .secondary)
                    : .outline,
                child: Row(
                  children: [
                    if (isSelected)
                      Icon(
                        FIcons.check,
                        color: isPrimary ? context.theme.colors.background : context.theme.colors.foreground,
                        fontWeight: .bold,
                      ),
                    SizedBox(width: 4),
                    Text(tag.name),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}