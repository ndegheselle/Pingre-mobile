import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tags_select.dart';
import 'package:pingre/screens/transactions/edit/value_input.dart';
import 'package:pingre/services/transactions.dart';

class TransactionEdit extends StatefulWidget {
  final Transaction? transaction;

  const TransactionEdit({super.key, this.transaction});

  @override
  State<TransactionEdit> createState() => _TransactionEditState();
}

class _TransactionEditState extends State<TransactionEdit> {
  late bool _isEditing;

  Set<String> _tagsId = {};
  late FDateFieldControl _dateControl;
  late FTimeFieldControl _timeControl;
  late FTextFieldControl _noteControl;
  late NumberValueController _valueController;

  @override
  void initState() {
    super.initState();

    _isEditing = widget.transaction != null;

    final initialDate = widget.transaction?.date ?? DateTime.now();
    _tagsId = widget.transaction?.tagsId ?? {};
    _valueController = NumberValueController(widget.transaction?.value ?? 0);
    _dateControl = FDateFieldControl.managed(initial: initialDate);
    _timeControl = FTimeFieldControl.managed(
      initial: FTime(initialDate.hour, initialDate.minute),
    );
    _noteControl = FTextFieldControl.managed(
      initial: TextEditingValue(text: widget.transaction?.notes ?? ""),
    );
  }

  void _save() {
    if (_isEditing) {
    } else {}
  }

  void _remove() {}

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
            ValueInput(controller: _valueController),
            SizedBox(height: 4),
            TagsSelect(
              initialSelection: _tagsId,
              onChanged: (value) => _tagsId = value,
            ),
            SizedBox(height: 8),
            FTextField.multiline(hint: 'Notes ...', control: _noteControl),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: FDateField(control: _dateControl, clearable: true),
                ),
                SizedBox(width: 4),
                SizedBox(
                  width: 100,
                  child: FTimeField(control: _timeControl, hour24: true),
                ),
              ],
            ),
            Spacer(),
            FButton(
              variant: .destructive,
              onPress: _remove,
              prefix: const Icon(FIcons.trash),
              child: const Text("Remove"),
            ),
            const SizedBox(height: 8),
            FButton(
              size: .lg,
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
