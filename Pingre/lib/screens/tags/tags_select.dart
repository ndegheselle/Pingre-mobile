import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/services/transactions.dart';
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
  late Tag? _primaryTag;
  late Set<String> _secondariesIds;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _primaryTag = widget.initialSelection?.primary;
    _secondariesIds =
        widget.initialSelection?.secondaries.map((t) => t.id).toSet() ?? {};
  }

  void _toggleTag(Tag tag) {
    setState(() {
      if (_primaryTag == null) {
        _primaryTag = tag;
      } else {
        _secondariesIds.add(tag.id);
      }
    });
  }

  void _setPrimaryTag(Tag tag) {
    if (_primaryTag == tag) return;
    setState(() {
      _primaryTag = tag;
    });
  }

  void _addTag() {
    var tag = Provider.of<TagsService>(
      context,
      listen: false,
    ).getOrCreate(_controller.text.trim());

    _toggleTag(tag);
    _controller.clear();
  }

  bool _isSelected(String id) {
    if (id == _primaryTag?.id) return true;
    return _secondariesIds.contains(id);
  }

  void _confirm() {
    if (_primaryTag == null) return Navigator.of(context).pop();

    var service = Provider.of<TagsService>(context, listen: false);
    var secondaries = _secondariesIds
        .map((id) => service.tagsMap[id]!)
        .toList();
    return Navigator.of(
      context,
    ).pop(TagsSelection(primary: _primaryTag!, secondaries: secondaries));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
        borderRadius: BorderRadius.only(
          topLeft: context.theme.style.borderRadius.topLeft,
          topRight: context.theme.style.borderRadius.topRight,
        ),
      ),
      child: Padding(
        padding: const .only(left: 8, right: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select tags",
              style: context.theme.typography.xl.copyWith(fontWeight: .bold),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: FTextField(
                    control: .managed(controller: _controller),
                    prefixBuilder: (context, style, variants) => Padding(
                      padding: .directional(start: 8),
                      child: Opacity(opacity: 0.5, child: Icon(FIcons.search)),
                    ),
                    hint: 'Tag name ...',
                    clearable: (value) => value.text.isNotEmpty,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _controller,
                  builder: (context, _, _) {
                    final showButton = _controller.text.isNotEmpty;
                    return AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      alignment: Alignment.centerRight,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: showButton ? 1.0 : 0.0,
                          child: Row(
                            children: [
                              SizedBox(width: 4),
                              FButton.icon(
                                variant: .outline,
                                onPress: _addTag,
                                child: const Icon(FIcons.plus),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, _, _) {
                      final search = _controller.text.trim();
                      return Consumer<TagsService>(
                        builder: (context, service, child) {
                          final filtered =
                              (search.isEmpty
                                      ? service.tags
                                      : service.search(search))
                                  .toList();
                          filtered.sort((a, b) {
                            if (a == _primaryTag) return -1;
                            if (b == _primaryTag) return 1;

                            final aSelected = _secondariesIds.contains(a.id);
                            final bSelected = _secondariesIds.contains(b.id);

                            if (aSelected != bSelected) return aSelected ? -1 : 1;

                            return b.updatedAt.compareTo(
                              a.updatedAt,
                            ); // newest first
                          });

                          return service.tags.isEmpty
                              ? const Center(
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text("No existing tag"),
                                  ),
                                )
                              : Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: filtered.map((tag) {
                                    final isSelected = _isSelected(tag.id);
                                    final isPrimary = tag.id == _primaryTag?.id;
                                    return GestureDetector(
                                      onLongPress: () => _setPrimaryTag(tag),
                                      onTap: () => _toggleTag(tag),
                                      child: FBadge(
                                        style: .delta(
                                          contentStyle: .delta(
                                            labelTextStyle: .delta(
                                              fontSize: context
                                                  .theme
                                                  .typography
                                                  .lg
                                                  .fontSize,
                                            ),
                                          ),
                                        ),
                                        variant: isSelected
                                            ? (isPrimary
                                                  ? .android
                                                  : .secondary)
                                            : .outline,
                                        child: Row(
                                          children: [
                                            if (isSelected)
                                              Icon(
                                                FIcons.check,
                                                color: context
                                                    .theme
                                                    .colors
                                                    .background,
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
                    },
                  ),
                ),
              ),
            ),
            FButton(
              onPress: _confirm,
              prefix: const Icon(FIcons.check),
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
