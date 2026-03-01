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

  String _search = '';

  void _addTag() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Provider.of<TagsService>(
      context,
      listen: false,
    ).addTag(Tag(name: name)); // duplicate check lives in the service
    _controller.clear();
    setState(() => _search = '');
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<TagsService>();
    final filteredTags = _search.isEmpty
        ? service.tags
        : service.tags
              .where(
                (t) => t.name.toLowerCase().contains(_search.toLowerCase()),
              )
              .toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FTextField(
                control: .managed(
                  controller: _controller,
                  onChange: (value) {
                    setState(() {
                      _search = value.text;
                    });
                  },
                ),
                hint: 'Tag name ...',
                clearable: (value) => value.text.isNotEmpty,
              ),
            ),
            const SizedBox(width: 4),
            FButton.icon(
              variant: .secondary,
              onPress: _addTag,
              child: const Icon(FIcons.plus),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: filteredTags.isEmpty
              ? const Center(child: Text('No tags found'))
              : FTileGroup(
                  divider: .full,
                  children: filteredTags
                      .map(
                        (tag) => FTile(
                          prefix: CircleAvatar(
                            backgroundColor:
                                tag.color ?? context.theme.colors.foreground,
                            radius: 6,
                          ),
                          style: const .delta(margin: .value(.zero)),
                          title: Text(tag.name),
                          suffix: const Icon(FIcons.chevronRight),
                          onPress: () => showTagEdit(context, tag),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
