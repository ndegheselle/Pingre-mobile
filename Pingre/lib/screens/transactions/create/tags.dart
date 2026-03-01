import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final List<Tag> _tags = [
    Tag(name: 'Work', color: Colors.red),
    Tag(name: 'Personal'),
    Tag(name: 'Urgent'),
  ];
  
  final FAutocompleteController _addTagController = FAutocompleteController();

  void _addItem() {
    final value = _addTagController.text.trim();
    if (value.isEmpty) return;

    setState(() {
      _tags.add(Tag(name: value));
    });

    _addTagController.clear();
  }

  void _removeItem(Tag item) {
    setState(() {
      _tags.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        ConstrainedBox(
          constraints: .new(maxHeight: 100),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 2,
                runSpacing: 4,
                children: _tags
                    .map(
                      (tag) => FBadge(
                        variant: .outline,
                        style: .delta(decoration: .delta(border: .all(color: tag.color ?? context.theme.colors.border))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(tag.name),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _removeItem(tag),
                              child: const Icon(FIcons.x, size: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: FAutocomplete(
                hint: 'Tag name ...',
                clearable: (value) => value.text.isNotEmpty,
                items: [],
                control: .managed(controller: _addTagController),
                onSubmit: (_) => _addItem(),
              ),
            ),
            SizedBox(width: 4),
            FButton.icon(
              variant: .secondary,
              onPress: _addItem,
              child: Icon(FIcons.plus),
            ),
          ],
        ),
      ],
    );
  }
}
