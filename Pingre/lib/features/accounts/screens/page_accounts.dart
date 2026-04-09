import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/accounts/screens/overlay_account_edit.dart';
import 'package:pingre/features/accounts/widgets/account_type_icon.dart';
import 'package:pingre/features/accounts/services/accounts.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/common/widgets/inputs/search_add.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PageAccounts extends StatefulWidget {
  const PageAccounts({super.key});

  @override
  State<PageAccounts> createState() => _PageAccountsState();
}

class _PageAccountsState extends State<PageAccounts> {
  final TextEditingController _controller = TextEditingController();

  void _addAccount(String name) {
    showAccountEdit(context, name: name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
        children: [
          SearchWithAdd(controller: _controller, onAdd: _addAccount),
          const SizedBox(height: 4),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, _, _) {
              return Expanded(
                child: Consumer<AccountsService>(
                  builder: (context, service, child) {
                    final filteredAccounts = _controller.text.isEmpty
                        ? service.accounts
                        : service.search(_controller.text);

                    return filteredAccounts.isEmpty
                        ? Center(child: Text(l10n.noAccountsFound))
                        : FTileGroup(
                            divider: .full,
                            children: filteredAccounts
                                .map(
                                  (account) => FTile(
                                    prefix: AccountTypeIcon(type: account.type),
                                    title: Text(account.name),
                                    subtitle: Text(account.description),
                                    details: ValueDisplay(value: account.balance),
                                    suffix: const Icon(FIcons.chevronRight),
                                    onPress: () => showAccountEdit(context, account: account),
                                  ),
                                )
                                .toList(),
                          );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 4),
        ],
      );
  }
}
