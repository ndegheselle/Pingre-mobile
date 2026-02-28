import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tags_page.dart';
import 'package:pingre/widgets/color_picker.dart';

class TagEdit extends StatefulWidget {
  final Tag tag;
  final VoidCallback onRemove;
  final ValueChanged<Tag> onSave;

  const TagEdit({super.key, required this.tag,     required this.onRemove,
    required this.onSave,});

  @override
  State<TagEdit> createState() => _TagEditState();
}

class _TagEditState extends State<TagEdit> {
  late final TextEditingController _nameController;
  late Color? _selectedColor;

  _TagEditState();

  void save()
  {
    widget.onSave(Tag(name: _nameController.text, color: _selectedColor));
  }

  void remove()
  {
    widget.onRemove();
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
            ColorPicker(initialColor: _selectedColor, onChanged: (color) => setState(() => _selectedColor = color)),
            const SizedBox(height: 4),
            FTextField(label: const Text("Name"), control: .managed(controller: _nameController),),
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
