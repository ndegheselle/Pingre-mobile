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
  
  void _save() {
    Provider.of<TagsService>(context, listen: false).updateTag(
      widget.tag.id,
      name: _nameController.text.trim(),
      color: _selectedColor,
    );
    Navigator.of(context).pop();
  }

  void _remove() {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Delete tag'),
        body: const Text(
          'Are you sure you want to delete this tag? This action cannot be undone.',
        ),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: const Text('Delete'),
            onPress: () {
              Provider.of<TagsService>(
                context,
                listen: false,
              ).removeTag(widget.tag.id);

              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          FButton(
            variant: .outline,
            size: .sm,
            child: const Text('Cancel'),
            onPress: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
        borderRadius: BorderRadius.only(
          topLeft: context.theme.style.borderRadius.topLeft,
          topRight: context.theme.style.borderRadius.topRight,
        ),
      ),
      child: Padding(
        padding: const .only(left: 8, right: 8, bottom: 8),
        child: Column(
          children: [
            Text("Edit tag", style: context.theme.typography.xl.copyWith(fontWeight: .bold)),
            const SizedBox(height: 4),
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
              onPress: _remove,
              prefix: const Icon(FIcons.trash),
              child: const Text("Remove"),
            ),
            const SizedBox(height: 8),
            FButton(
              onPress: _save,
              prefix: const Icon(FIcons.save),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
