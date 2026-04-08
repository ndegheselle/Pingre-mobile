import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/transactions/screens/transaction_form_fields.dart';
import 'package:pingre/features/recurring/services/recurring.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/common/widgets/inputs/time_range_select.dart';
import 'package:pingre/common/widgets/layout/sheet_container.dart';
import 'package:provider/provider.dart';

/// Show the recurring transaction edit page as a sheet
Future<dynamic> showRecurringTransactionEdit(
  BuildContext context, {
  RecurringTransaction? recurringTransaction,
  String? name,
}) {
  return showFSheet(
    mainAxisMaxRatio: 8 / 10,
    context: context,
    side: .btt,
    builder: (context) => RecurringTransactionEdit(
      recurringTransaction: recurringTransaction,
      name: name,
    ),
  );
}

class RecurringTransactionEdit extends StatefulWidget {
  final RecurringTransaction? recurringTransaction;
  final String? name;

  const RecurringTransactionEdit({
    super.key,
    this.recurringTransaction,
    this.name,
  });

  @override
  State<RecurringTransactionEdit> createState() =>
      _RecurringTransactionEditState();
}

class _RecurringTransactionEditState extends State<RecurringTransactionEdit> {
  late bool _isEditing;
  late TransactionFormData _formData;
  late TextEditingController _nameController;
  late TimeRangeUnit _range;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _isEditing = widget.recurringTransaction != null;
    _formData = TransactionFormData.fromTransaction(
      widget.recurringTransaction?.transaction,
    );
    _nameController = TextEditingController(
      text: widget.recurringTransaction?.name ?? widget.name ?? "",
    );
    _range = widget.recurringTransaction?.range ?? TimeRangeUnit.month;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final name = _nameController.text.trim();
    final service = context.read<RecurringTransactionsService>();

    if (_isEditing) {
      service.update(
        widget.recurringTransaction!.id,
        name: name,
        transaction: Transaction(
          value: _formData.value,
          date: _formData.date,
          tags: _formData.tags!,
          notes: _formData.notes,
        ),
        range: _range,
      );
    } else {
      service.create(
        RecurringTransaction(
          name: name,
          transaction: Transaction(
            value: _formData.value,
            date: _formData.date,
            tags: _formData.tags!,
            notes: _formData.notes,
          ),
          range: _range,
        ),
      );
    }

    _onSaved();
  }

  void _onSaved() {
    showFToast(
      context: context,
      alignment: .topCenter,
      icon: const Icon(FIcons.check),
      title: const Text("Saved"),
      description: const Text("The recurring transaction has been saved"),
    );
    Navigator.of(context).pop();
  }

  void _remove() {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Remove recurring transaction'),
        body: const Text(
          'Are you sure you want to remove this recurring transaction?',
        ),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: const Text('Remove'),
            onPress: () {
              context.read<RecurringTransactionsService>().remove(
                widget.recurringTransaction!.id,
              );

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
      icon: const Icon(FIcons.check),
      title: const Text("Removed"),
      description: const Text("The recurring transaction has been removed"),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      title: _isEditing
          ? "Edit recurring transaction"
          : "New recurring transaction",
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 4),
            TimeRangeSelect(
              value: _range,
              onChanged: (unit) => setState(() => _range = unit),
            ),
            const SizedBox(height: 4),
            FormField<String>(
              validator: (_) => _nameController.text.trim().isEmpty
                  ? "A name is required."
                  : null,
              builder: (state) => FTextField(
                error: state.errorText == null ? null : Text(state.errorText!),
                hint: 'Name',
                control: .managed(controller: _nameController),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: TransactionFormFields(formData: _formData),
            ),
            if (_isEditing)
              Padding(
                padding: const .only(top: 8),
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
              prefix: const Icon(FIcons.save),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
