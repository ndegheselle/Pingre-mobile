import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/accounts/models/account.dart';
import 'package:pingre/features/accounts/widgets/account_type_icon.dart';
import 'package:pingre/features/accounts/services/accounts.dart';
import 'package:pingre/common/widgets/data/error_display.dart';
import 'package:pingre/common/widgets/inputs/value_input.dart';
import 'package:pingre/common/widgets/layout/sheet_container.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Show the account edit page in a sheet
Future<dynamic> showAccountEdit(
  BuildContext context, {
  Account? account,
  String? name,
}) {
  return showFSheet(
    mainAxisMaxRatio: 7 / 10,
    context: context,
    side: .btt,
    builder: (context) => OverlayAccountEdit(account: account, name: name),
  );
}

class OverlayAccountEdit extends StatefulWidget {
  final Account? account;
  final String? name;

  const OverlayAccountEdit({super.key, this.account, this.name});

  @override
  State<OverlayAccountEdit> createState() => _OverlayAccountEditState();
}

class _OverlayAccountEditState extends State<OverlayAccountEdit> {
  late bool _isEditing;
  final Map<String, String> _errors = {};

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late AccountType _selectedType;
  late NumberValueController _balanceController;

  @override
  void initState() {
    super.initState();

    _isEditing = widget.account != null;
    _selectedType = widget.account?.type ?? AccountType.checking;
    _balanceController = NumberValueController(
      widget.account?.balance ?? Decimal.zero,
    );
    _nameController = TextEditingController(
      text: widget.account?.name ?? widget.name ?? "",
    );
    _descriptionController = TextEditingController(
      text: widget.account?.description ?? "",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    final service = context.read<AccountsService>();

    if (_nameController.text.isEmpty) {
      return setState(() {
        _errors["name"] = l10n.accountNameRequired;
      });
    }

    if (_isEditing) {
      service.update(
        widget.account!.id,
        name: _nameController.text,
        description: _descriptionController.text,
        type: _selectedType,
        balance: _balanceController.value,
      );
    } else {
      service.create(
        Account(
          name: _nameController.text,
          description: _descriptionController.text,
          type: _selectedType,
          balance: _balanceController.value,
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
      description: Text(l10n.accountSavedDesc),
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
        title: Text(l10n.accountRemovedDialogTitle),
        body: Text(l10n.accountRemovedDialogBody),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: Text(l10n.actionRemove),
            onPress: () {
              context.read<AccountsService>().remove(widget.account!.id);
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
      description: Text(l10n.accountRemovedDesc),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SheetContainer(
      title: _isEditing ? l10n.editAccount : l10n.newAccount,
      child: Column(
        children: [
          const SizedBox(height: 8),
          ValueInput(controller: _balanceController),
          const SizedBox(height: 4),
          FSelect<AccountType>.rich(
            hint: l10n.accountTypeHint,
            format: (type) => type.localizedName(l10n),
            control: .lifted(
              value: _selectedType,
              onChange: (value) => setState(() => _selectedType = value!),
            ),
            children: [
              for (final type in AccountType.values)
                .item(
                  prefix: AccountTypeIcon(type: type),
                  title: Text(type.localizedName(l10n)),
                  subtitle: Text(type.localizedDescription(l10n)),
                  value: type,
                ),
            ],
          ),
          const SizedBox(height: 4),
          ErrorDisplay(
            error: _errors["name"],
            child: FTextField(
              hint: l10n.accountNameHint,
              control: .managed(controller: _nameController),
            ),
          ),
          const SizedBox(height: 4),
          FTextField.multiline(
            hint: l10n.accountDescriptionHint,
            control: .managed(controller: _descriptionController),
          ),
          const Spacer(),
          if (_isEditing)
            Padding(
              padding: const .directional(top: 8),
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
