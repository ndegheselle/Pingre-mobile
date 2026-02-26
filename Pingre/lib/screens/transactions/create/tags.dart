import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final List<String> items = [
    'Apple',
    'Banana',
    'Orange',
    'Mango',
    'Pineapple',
    'Strawberry',
  ];
  final FAutocompleteController _addTagController = FAutocompleteController();

  void _addItem() {
    final value = _addTagController.text.trim();
    if (value.isEmpty) return;

    setState(() {
      items.add(value);
    });

    _addTagController.clear();
  }

  void _removeItem(String item) {
    setState(() {
      items.remove(item);
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
                children: items
                    .map(
                      (text) => FBadge(
                        variant: .outline,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(text),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _removeItem(text),
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
                items: items,
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
