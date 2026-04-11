import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pingre/features/recurring/screens/overlay_recurring_edit.dart';
import 'package:pingre/features/recurring/services/recurring.dart';
import 'package:pingre/features/recurring/widgets/recurring_tile_group.dart';
import 'package:pingre/common/widgets/inputs/search_add.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PageRecurring extends StatefulWidget {
  const PageRecurring({super.key});

  @override
  State<PageRecurring> createState() => _PageRecurringState();
}

class _PageRecurringState extends State<PageRecurring> {
  final TextEditingController _controller = TextEditingController();

  void _addRecurring(String name) {
    showRecurringTransactionEdit(context, name: name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SearchWithAdd(controller: _controller, onAdd: _addRecurring),
        const SizedBox(height: 4),
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, _, _) {
            return Expanded(
              child: Consumer<RecurringTransactionsService>(
                builder: (context, service, child) {
                  final filteredRecurring = _controller.text.isEmpty
                      ? service.recurringTransactions
                      : service.search(_controller.text);

                  final negatives = filteredRecurring
                      .where((r) => r.transaction.value < Decimal.zero)
                      .sortedBy((r) => r.name);
                  final positives = filteredRecurring
                      .where((r) => r.transaction.value > Decimal.zero)
                      .sortedBy((r) => r.name);

                  return filteredRecurring.isEmpty
                      ? Center(child: Text(l10n.noRecurringFound))
                      : ListView(
                          children: [
                            if (positives.isNotEmpty)
                               RecurringTileGroup(
                                label: l10n.positives,
                                items: positives,
                              ),
                            if (negatives.isNotEmpty)
                              RecurringTileGroup(
                                label: l10n.negatives,
                                items: negatives,
                              ),
                          ],
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
