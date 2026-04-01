import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/transactions/transaction_form_fields.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/layout/sheet_container.dart';
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
  late TransactionFormData _formData;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _isEditing = widget.transaction != null;
    _formData = TransactionFormData.fromTransaction(widget.transaction);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final service = context.read<TransactionsService>();

    if (_isEditing) {
      service.update(
        widget.transaction!.id,
        value: _formData.value,
        tags: _formData.tags,
        date: _formData.date,
        notes: _formData.notes,
      );
    } else {
      service.create(
        Transaction(
          value: _formData.value,
          date: _formData.date,
          tags: _formData.tags!,
          notes: _formData.notes,
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
      description: const Text("The transaction has been edited"),
    );
    Navigator.of(context).pop();
  }

  void _remove() {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Removed transaction'),
        body: const Text(
          'Are you sure you want to remove this transaction?',
        ),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: const Text('Remove'),
            onPress: () {
              context
                  .read<TransactionsService>()
                  .remove(widget.transaction!.id);

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
      description: const Text("The transaction has been removed"),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      title: _isEditing ? "Edit transaction" : "New transaction",
      child: Column(
        children: [
          const SizedBox(height: 4),

          /// Reusable form
          Expanded(
            child: Form(
              key: _formKey,
              child: TransactionFormFields(formData: _formData),
            ),
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
    );
  }
}