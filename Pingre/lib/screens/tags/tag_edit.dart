import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/widgets/color_picker.dart';
import 'package:provider/provider.dart';

Future<dynamic> showTagEdit(BuildContext context, Tag tag) {
  return showFSheet(
    context: context,
    side: .btt,
    builder: (context) => TagEdit(tag: tag),
  );
}

class TagEdit extends StatefulWidget {
  final Tag tag;

  const TagEdit({super.key, required this.tag});

  @override
  State<TagEdit> createState() => _TagEditState();
}

class _TagEditState extends State<TagEdit> {
  late final TextEditingController _nameController;
  late Color? _selectedColor;

  _TagEditState();

  void save() {
    Provider.of<TagsService>(context, listen: false).updateTag(
      widget.tag.id,
      name: _nameController.text.trim(),
      color: _selectedColor,
    );
    Navigator.of(context).pop();
  }

  void remove() {
    Provider.of<TagsService>(context, listen: false).removeTag(widget.tag.id);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag.name);
    _selectedColor = widget.tag.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
          children: [
            ColorPicker(
              initialColor: _selectedColor,
              onChanged: (color) => setState(() => _selectedColor = color),
            ),
            const SizedBox(height: 4),
            FTextField(
              label: const Text("Name"),
              control: .managed(controller: _nameController),
            ),
            const Spacer(),

            FButton(
              variant: .destructive,
              onPress: remove,
              prefix: const Icon(FIcons.trash),
              child: const Text("Remove"),
            ),
            const SizedBox(height: 8),
            FButton(
              onPress: save,
              prefix: const Icon(FIcons.save),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
