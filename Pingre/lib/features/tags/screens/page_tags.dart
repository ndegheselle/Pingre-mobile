import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/tags/screens/overlay_tag_edit.dart';
import 'package:pingre/features/tags/services/tags.dart';
import 'package:pingre/common/widgets/inputs/search_add.dart';
import 'package:provider/provider.dart';

class PageTags extends StatefulWidget {
  const PageTags({super.key});

  @override
  State<PageTags> createState() => _PageTagsState();
}

class _PageTagsState extends State<PageTags> {
  final TextEditingController _controller = TextEditingController();

  void _addTag(String name) {
    var tag = context.read<TagsService>().createIfMissing(name);
    showTagEdit(context, tag);
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Tags'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.pop(context))],
      ),
      child: Column(
        children: [
          SearchWithAdd(controller: _controller, onAdd: _addTag),
          const SizedBox(height: 4),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, _, _) {
              return Expanded(
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
              );
            },
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
