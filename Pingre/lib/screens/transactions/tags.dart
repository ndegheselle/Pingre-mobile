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

  void _addItem() {
    setState(() {
      items.add('Item ${items.length + 1}');
    });
  }

  void _removeItem(String item) {
    setState(() {
      items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 2,
          runSpacing: 2,
          children: [
            ...items.map(
              (text) => FBadge(
                variant: .outline,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeItem(text),
                      child: const Icon(FIcons.x),
                    ),
                  ],
                ),
              ),
            ),
            FButton(
              onPress: () => {},
              prefix: const Icon(FIcons.plus),
              size: .xs,
              child: const Text("new"),
            ),
          ],
        ),
      ],
    );
  }
}
