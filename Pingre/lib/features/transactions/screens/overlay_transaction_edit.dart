import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/widgets/transaction_form_fields.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/common/widgets/layout/sheet_container.dart';
import 'package:pingre/l10n/app_localizations.dart';
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
    builder: (context) => OverlayTransactionEdit(transaction: transaction),
  );
}

class OverlayTransactionEdit extends StatefulWidget {
  final Transaction? transaction;

  const OverlayTransactionEdit({super.key, this.transaction});

  @override
  State<OverlayTransactionEdit> createState() => _OverlayTransactionEditState();
}

class _OverlayTransactionEditState extends State<OverlayTransactionEdit> {
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
    final l10n = AppLocalizations.of(context)!;
    showFToast(
      context: context,
      alignment: .topCenter,
      icon: const Icon(FIcons.check),
      title: Text(l10n.toastSavedTitle),
      description: Text(l10n.transactionSavedDesc),
    );
    Navigator.of(context).pop();
  }

  void _remove() {
    final l10n = AppLocalizations.of(context)!;
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: Text(l10n.transactionRemovedDialogTitle),
        body: Text(l10n.transactionRemovedDialogBody),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: Text(l10n.actionRemove),
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
            child: Text(l10n.actionCancel),
            onPress: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _onRemove() {
    final l10n = AppLocalizations.of(context)!;
    showFToast(
      context: context,
      alignment: .topCenter,
      icon: const Icon(FIcons.check),
      title: Text(l10n.toastRemovedTitle),
      description: Text(l10n.transactionRemovedDesc),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SheetContainer(
      title: _isEditing ? l10n.editTransaction : l10n.newTransaction,
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
                child: Text(l10n.actionRemove),
              ),
            ),

          const SizedBox(height: 8),
          FButton(
            onPress: _save,
            prefix: const Icon(FIcons.save),
            child: Text(l10n.actionSave),
          ),
        ],
      ),
    );
  }
}
