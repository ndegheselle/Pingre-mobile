import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/widgets/inputs/color_picker.dart';
import 'package:pingre/widgets/layout/sheet_container.dart';
import 'package:provider/provider.dart';

/// Show the tag edit page in a sheet
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

  /// Update the tag
  void _save() {
   context.read<TagsService>().update(
      widget.tag.id,
      name: _nameController.text.trim(),
      color: _selectedColor,
    );
    _onSaved();
  }

  void _onSaved() {
    showFToast(
      context: context,
      alignment: .topCenter,
      icon: const Icon(FIcons.check),
      title: const Text("Saved"),
      description: const Text("The tag has been edited"),
    );
    Navigator.of(context).pop();
  }

  /// Show a dialog to ask if the user want to remove the tag and then remove it
  void _remove() {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Remove tag'),
        body: const Text(
          'Are you sure you want to remove this tag? This action cannot be undone.',
        ),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: const Text('Remove'),
            onPress: () {
              context.read<TagsService>().remove(widget.tag.id);
              _onRemoved();
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

  void _onRemoved() {
    showFToast(
      context: context,
      alignment: .topCenter,
      icon: const Icon(FIcons.check),
      title: const Text("Removed"),
      description: const Text("The tag has been removed"),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      title: "Edit tag",
      child: Column(
        children: [
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
    );
  }
}
