import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tag_edit.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/widgets/inputs/search_add.dart';
import 'package:provider/provider.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
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
