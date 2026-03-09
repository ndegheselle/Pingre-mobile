import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tag_edit.dart';
import 'package:pingre/services/tags.dart';
import 'package:provider/provider.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  final TextEditingController _controller = TextEditingController();

  void _addTag() {
    context.read<TagsService>().createIfMissing(_controller.text.trim());

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, _, _) {
        final showButton = _controller.text.isNotEmpty;
        return Column(
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
                AnimatedSize(
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
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Consumer<TagsService>(
                builder: (context, service, child) {
                  final filteredTags = _controller.text.isEmpty
                      ? service.tags
                      : service.search(_controller.text);

                  return filteredTags.isEmpty
                      ? const Center(child: Text('No tags found'))
                      : FTileGroup(
                          divider: .full,
                          children: filteredTags
                              .map(
                                (tag) => FTile(
                                  prefix: CircleAvatar(
                                    backgroundColor:
                                        tag.color ??
                                        context.theme.colors.foreground,
                                    radius: 6,
                                  ),
                                  title: Text(tag.name),
                                  suffix: const Icon(FIcons.chevronRight),
                                  onPress: () => showTagEdit(context, tag),
                                ),
                              )
                              .toList(),
                        );
                },
              ),
            ),
            const SizedBox(height: 4),
          ],
        );
      },
    );
  }
}
