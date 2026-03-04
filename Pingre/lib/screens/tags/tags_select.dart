import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:provider/provider.dart';

Future<Set<String>?> showTagsSelect(BuildContext context, {Set<String>? initialSelection}) {
  return showFSheet<Set<String>>(
    mainAxisMaxRatio: 6 / 10,
    context: context,
    side: .btt,
    builder: (context) => TagsSelect(initialSelection: initialSelection),
  );
}

class TagsSelect extends StatefulWidget {
  final Set<String>? initialSelection;
  final ValueChanged<Set<String>>? onChanged;

  const TagsSelect({super.key, this.initialSelection, this.onChanged});
  @override
  State<TagsSelect> createState() => _TagsSelectState();
}

class _TagsSelectState extends State<TagsSelect> {
  late Set<String> _selected = {};
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection ?? {};
  }

  void _toggleTag(Tag tag) {
    setState(() {
      if (_selected.contains(tag.id)) {
        _selected.remove(tag.id);
      } else {
        _selected.add(tag.id);
      }
    });
    widget.onChanged?.call(Set.unmodifiable(_selected));
  }

  void _addTag() {
    var tag = Provider.of<TagsService>(
      context,
      listen: false,
    ).getOrCreate(_controller.text.trim());

    _toggleTag(tag);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
      ),
      child: Padding(
        padding: const .all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      alignment: Alignment.centerRight, // grows left → right
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
                            final aSelected = _selected.contains(a.id);
                            final bSelected = _selected.contains(b.id);

                            if (aSelected != bSelected) {
                              return aSelected ? -1 : 1; // selected first
                            }

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
                                    final isSelected = _selected.contains(
                                      tag.id,
                                    );
                                    return GestureDetector(
                                      onTap: () => _toggleTag(tag),
                                      child: FBadge(
                                        style: .delta(contentStyle: .delta(labelTextStyle: .delta(fontSize: context.theme.typography.lg.fontSize))),
                                        variant: isSelected
                                            ? .android
                                            : .outline,
                                        child: Row(children: [
                                          if (isSelected)
                                            Icon(FIcons.check, color: context.theme.colors.background, fontWeight: .bold,),
                                          SizedBox(width: 4),
                                          Text(tag.name)
                                        ],),
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
              onPress: () => Navigator.of(context).pop(_selected),
              prefix: const Icon(FIcons.check),
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
