import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/accounts/account_type_icon.dart';
import 'package:pingre/services/accounts.dart';
import 'package:pingre/widgets/data/error_display.dart';
import 'package:pingre/widgets/inputs/value_input.dart';
import 'package:pingre/widgets/layout/sheet_container.dart';
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
    builder: (context) => AccountEdit(account: account, name: name),
  );
}

class AccountEdit extends StatefulWidget {
  final Account? account;
  final String? name;

  const AccountEdit({super.key, this.account, this.name});

  @override
  State<AccountEdit> createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {
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
    final service = context.read<AccountsService>();

    if (_nameController.text.isEmpty) {
      return setState(() {
        _errors["name"] = "Name is required.";
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
    showFToast(
      context: context,
      alignment: .topCenter,
      icon: const Icon(FIcons.check),
      title: const Text("Saved"),
      description: const Text("The account has been saved"),
    );
    Navigator.of(context).pop();
  }

  void _remove() {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Remove account'),
        body: const Text(
          'Are you sure you want to remove this account? This action cannot be undone.',
        ),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: const Text('Remove'),
            onPress: () {
              context.read<AccountsService>().remove(widget.account!.id);
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
      description: const Text("The account has been removed"),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      title: _isEditing ? "Edit account" : "New account",
      child: Column(
        children: [
          const SizedBox(height: 8),
          ValueInput(controller: _balanceController),
          const SizedBox(height: 4),
          FSelect<AccountType>.rich(
            hint: 'Type',
            format: (type) => type.name,
            control: .lifted(
              value: _selectedType,
              onChange: (value) => setState(() => _selectedType = value!),
            ),
            children: [
              for (final type in AccountType.values)
                .item(
                  prefix: AccountTypeIcon(type: type),
                  title: Text(type.name),
                  subtitle: Text(type.description),
                  value: type,
                ),
            ],
          ),
          const SizedBox(height: 4),
          ErrorDisplay(
            error: _errors["name"],
            child: FTextField(
              hint: 'Name',
              control: .managed(controller: _nameController),
            ),
          ),
          const SizedBox(height: 4),
          FTextField.multiline(
            hint: 'Description',
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
