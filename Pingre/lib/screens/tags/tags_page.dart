import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class Tag {
  Tag({required this.name, this.color});

  String name;
  Color? color;
}

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Tag> _tags = [
    Tag(name: 'Work', color: Colors.blue),
    Tag(name: 'Personal', color: Colors.green),
    Tag(name: 'Urgent', color: Colors.red),
  ];

  String _search = '';

  List<Tag> get _filteredTags {
    if (_search.isEmpty) return _tags;
    return _tags
        .where((t) => t.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  void _addTag() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    final exists = _tags.any((t) => t.name.toLowerCase() == name.toLowerCase());
    if (exists) return;

    setState(() {
      _tags.add(Tag(name: name));
      _controller.clear();
      _search = '';
    });
  }

  void _removeTag(Tag tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) => Column(
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
              prefixBuilder: (context, style, variants) => const Padding(
                padding: EdgeInsetsDirectional.only(start: 8),
                child: Icon(FIcons.search),
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
        child: _filteredTags.isEmpty
            ? const Center(child: Text('No tags found'))
            : FTileGroup(
                divider: .full,
                children: _tags
                    .map(
                      (tag) => FTile(
                        prefix: CircleAvatar(
                          backgroundColor:
                              tag.color ?? Theme.of(context).primaryColor,
                          radius: 6,
                        ),
                        style: const .delta(margin: .value(.zero)),
                        title: Text(tag.name),
                        suffix: const Icon(FIcons.chevronRight),
                      ),
                    )
                    .toList(),
              ),
      ),
      const SizedBox(height: 4),
    ],
  );
}
