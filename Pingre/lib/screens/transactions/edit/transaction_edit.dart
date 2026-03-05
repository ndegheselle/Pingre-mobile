import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tags_display.dart';
import 'package:pingre/screens/tags/tags_select.dart';
import 'package:pingre/screens/transactions/edit/value_input.dart';
import 'package:pingre/services/transactions.dart';

Future<dynamic> showTagEdit(BuildContext context, {Transaction? transaction}) {
  return showFSheet(
    mainAxisMaxRatio: 7 / 10,
    context: context,
    side: .btt,
    builder: (context) => TransactionEdit(transaction: transaction),
  );
}

class TransactionEdit extends StatefulWidget {
  final Transaction? transaction;

  const TransactionEdit({super.key, this.transaction});

  @override
  State<TransactionEdit> createState() => _TransactionEditState();
}

class _TransactionEditState extends State<TransactionEdit> {
  late bool _isEditing;

  TagsSelection? _tagsSelection;
  late FDateFieldControl _dateControl;
  late FTimeFieldControl _timeControl;
  late FTextFieldControl _noteControl;
  late NumberValueController _valueController;

  @override
  void initState() {
    super.initState();

    _isEditing = widget.transaction != null;

    final initialDate = widget.transaction?.date ?? DateTime.now();
    _tagsSelection = widget.transaction?.tags;
    _valueController = NumberValueController(widget.transaction?.value ?? -1);
    _dateControl = FDateFieldControl.managed(initial: initialDate);
    _timeControl = FTimeFieldControl.managed(
      initial: FTime(initialDate.hour, initialDate.minute),
    );
    _noteControl = FTextFieldControl.managed(
      initial: TextEditingValue(text: widget.transaction?.notes ?? ""),
    );
  }

  void _selectTags() async {
    final selection = await showTagsSelect(
      context,
      initialSelection: _tagsSelection,
    );
    if (selection != null) {
      setState(() {
        _tagsSelection = selection;
      });
    }
  }

  void _save() {
    if (_isEditing) {
    } else {}
  }

  void _remove() {
    showFSheet(
      context: context,
      style: const .delta(flingVelocity: 700),
      side: .btt,
      builder: (context) =>
          const Padding(padding: .all(16), child: Text('Sheet content')),
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
            Text(
              _isEditing ? "Edit transaction" : "New transaction",
              style: context.theme.typography.xl.copyWith(fontWeight: .bold),
            ),
            SizedBox(height: 4),
            ValueInput(controller: _valueController),
            SizedBox(height: 4),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tagsId.isEmpty
                      ? const Center(
                          child: Opacity(opacity: 0.5, child: Text("No tags")),
                        )
                      : TagsDisplay(tagIds: _tagsId),
                  SizedBox(height: 4),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: FButton(
                        size: .sm,
                        variant: .secondary,
                        onPress: _selectTags,
                        prefix: const Icon(FIcons.tag),
                        child: const Text("Select tags"),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4),
            FTextField.multiline(hint: 'Notes ...', control: _noteControl),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: FDateField(control: _dateControl)),
                SizedBox(width: 4),
                SizedBox(
                  width: 100,
                  child: FTimeField(control: _timeControl, hour24: true),
                ),
              ],
            ),
            if (_isEditing)
              FButton(
                variant: .destructive,
                onPress: _remove,
                prefix: const Icon(FIcons.trash),
                child: const Text("Remove"),
              ),
            const SizedBox(height: 8),
            FButton(
              onPress: _save,
              prefix: Icon(FIcons.save),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
