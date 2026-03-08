import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/widgets/color_picker.dart';
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
    Provider.of<TagsService>(context, listen: false).update(
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
      title: const Row(
        mainAxisSize: .min,
        children: [Icon(FIcons.check), SizedBox(width: 4), Text('Saved')],
      ),
      description: const Text("The tag has been edited"),
      suffixBuilder: (context, entry) => IntrinsicHeight(
        child: FButton.icon(
          variant: .ghost,
          onPress: entry.dismiss,
          child: const Icon(FIcons.x),
        ),
      ),
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
              Provider.of<TagsService>(
                context,
                listen: false,
              ).remove(widget.tag.id);

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
      title: const Row(
        mainAxisSize: .min,
        children: [Icon(FIcons.check), SizedBox(width: 4), Text('Removed')],
      ),
      description: const Text('The tag has been removed'),
      suffixBuilder: (context, entry) => IntrinsicHeight(
        child: FButton.icon(
          variant: .ghost,
          onPress: entry.dismiss,
          child: const Icon(FIcons.x),
        ),
      ),
    );
    Navigator.of(context).pop();
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
            Text(
              "Edit tag",
              style: context.theme.typography.xl.copyWith(fontWeight: .bold),
            ),
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
