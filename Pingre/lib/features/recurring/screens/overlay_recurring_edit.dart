import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/recurring/models/recurring.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/widgets/transaction_form_fields.dart';
import 'package:pingre/features/recurring/services/recurring.dart';
import 'package:pingre/common/widgets/inputs/time_range_select.dart';
import 'package:pingre/common/widgets/layout/sheet_container.dart';
import 'package:pingre/l10n/app_localizations.dart';
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
    builder: (context) => OverlayRecurringTransactionEdit(
      recurringTransaction: recurringTransaction,
      name: name,
    ),
  );
}

class OverlayRecurringTransactionEdit extends StatefulWidget {
  final RecurringTransaction? recurringTransaction;
  final String? name;

  const OverlayRecurringTransactionEdit({
    super.key,
    this.recurringTransaction,
    this.name,
  });

  @override
  State<OverlayRecurringTransactionEdit> createState() =>
      _OverlayRecurringTransactionEditState();
}

class _OverlayRecurringTransactionEditState
    extends State<OverlayRecurringTransactionEdit> {
  late bool _isEditing;
  late TransactionFormData _formData;
  late TextEditingController _nameController;
  late TimeRangeUnit _range;
  late bool _isActive;
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
    _isActive = widget.recurringTransaction?.isActive ?? true;
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
        isActive: _isActive,
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
          isActive: _isActive,
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
      description: Text(l10n.recurringSavedDesc),
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
        title: Text(l10n.recurringRemovedDialogTitle),
        body: Text(l10n.recurringRemovedDialogBody),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: Text(l10n.actionRemove),
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
      description: Text(l10n.recurringRemovedDesc),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SheetContainer(
      title: _isEditing ? l10n.editRecurring : l10n.newRecurring,
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
            Row(
              children: [
                Expanded(child: FormField<String>(
                  validator: (_) => _nameController.text.trim().isEmpty
                      ? l10n.nameRequired
                      : null,
                  builder: (state) => FTextField(
                    error: state.errorText == null
                        ? null
                        : Text(state.errorText!),
                    hint: l10n.nameHint,
                    control: .managed(controller: _nameController),
                  ),
                )),
                FSwitch(
                  value: _isActive,
                  onChange: (v) => setState(() => _isActive = v),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(child: TransactionFormFields(formData: _formData)),
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
      ),
    );
  }
}
