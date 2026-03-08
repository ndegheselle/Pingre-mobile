import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tags_display.dart';
import 'package:pingre/screens/tags/tags_select.dart';
import 'package:pingre/screens/transactions/edit/value_input.dart';
import 'package:pingre/services/transactions.dart';
import 'package:provider/provider.dart';

/// Show the transaction edit page as a sheet
Future<dynamic> showTransactionEdit(
  BuildContext context, {
  Transaction? transaction,
}) {
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
  late TextEditingController _noteController;
  late FTimeFieldController _timeController;
  late FDateFieldController _dateController;
  late NumberValueController _valueController;

  @override
  void initState() {
    super.initState();

    _isEditing = widget.transaction != null;

    final initialDate = widget.transaction?.date ?? DateTime.now();
    _tagsSelection = widget.transaction?.tags;
    _valueController = NumberValueController(
      widget.transaction?.value ?? Decimal.fromInt(-1),
    );

    _dateController = FDateFieldController(date: initialDate);
    _timeController = FTimeFieldController(
      time: FTime(initialDate.hour, initialDate.minute),
    );
    _noteController = TextEditingController(
      text: widget.transaction?.notes ?? "",
    );
  }

  /// Show the tag select page
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

  /// Either save or update the transaction if already existing
  void _save() {
    var service = Provider.of<TransactionsService>(context, listen: false);
    DateTime date = DateTime(
      _dateController.value!.year,
      _dateController.value!.month,
      _dateController.value!.day,
      _timeController.value!.hour,
      _timeController.value!.minute,
    );
    if (_isEditing) {
      service.update(
        widget.transaction!.id,
        value: _valueController.value,
        tags: _tagsSelection,
        date: date,
        notes: _noteController.text,
      );
    } else {
      Transaction transaction = Transaction(
        value: _valueController.value,
        date: date,
        tags: _tagsSelection!,
        notes: _noteController.text,
      );
      service.create(transaction);
    }

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
      description: const Text("The transaction has been edited"),
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

  /// Show a dialog to ask if the user want to remove the transaction and then remove it
  void _remove() {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Removed transaction'),
        body: const Text(
          'Are you sure you want to remove this transaction? This action cannot be undone.',
        ),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: const Text('Remove'),
            onPress: () {
              Provider.of<TransactionsService>(
                context,
                listen: false,
              ).remove(widget.transaction!.id);

              _onRemove();
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

  void _onRemove() {
    showFToast(
      context: context,
      alignment: .topCenter,
      title: const Row(
        mainAxisSize: .min,
        children: [Icon(FIcons.check), SizedBox(width: 4), Text('Removed')],
      ),
      description: const Text("The transaction has been removed"),
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
                  TagsDisplay(selection: _tagsSelection),
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
            FTextField.multiline(
              hint: 'Notes',
              control: .managed(controller: _noteController),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: FDateField(
                    control: .managed(controller: _dateController),
                  ),
                ),
                SizedBox(width: 4),
                SizedBox(
                  width: 100,
                  child: FTimeField(
                    control: .managed(controller: _timeController),
                    hour24: true,
                  ),
                ),
              ],
            ),
            if (_isEditing)
              Padding(
                padding: .directional(top: 8),
                child: FButton(
                  variant: .destructive,
                  onPress: _remove,
                  prefix: const Icon(FIcons.trash),
                  child: const Text("Remove"),
                ),
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
