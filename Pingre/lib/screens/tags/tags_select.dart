import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:provider/provider.dart';

class TagsSelect extends StatefulWidget {
  final List<Tag> initialSelection;

  const TagsSelect({super.key, this.initialSelection = const []});
  @override
  State<TagsSelect> createState() => _TagsSelectState();
}

class _TagsSelectState extends State<TagsSelect> {
  final FAutocompleteController _addTagController = FAutocompleteController();
  late List<Tag> _selection;

  @override
  void initState() {
    super.initState();
    _selection = List<Tag>.from(widget.initialSelection);
  }

  void _addItem() {
    final service = context.read<TagsService>();
    final tag = service.getOrCreate(_addTagController.text);

    if (!_selection.contains(tag)) return;
    setState(() {
      _selection.add(tag);
    });

    _addTagController.clear();
  }

  void _removeItem(Tag item) {
    setState(() {
      _selection.remove(item);
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
                children: _selection
                    .map(
                      (tag) => FBadge(
                        variant: .outline,
                        style: .delta(
                          decoration: .delta(
                            border: .all(
                              color: tag.color ?? context.theme.colors.border,
                            ),
                          ),
                        ),
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
              child: Consumer<TagsService>(
                builder: (context, service, child) => FAutocomplete(
                  hint: 'Tag name ...',
                  clearable: (value) => value.text.isNotEmpty,
                  items: service.tags.map((t) => t.name).toList(),
                  control: .managed(controller: _addTagController),
                  onSubmit: (_) => _addItem(),
                ),
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
