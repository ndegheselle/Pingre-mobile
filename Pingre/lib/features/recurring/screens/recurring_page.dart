import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range_icon.dart';
import 'package:pingre/features/recurring/screens/recurring_edit.dart';
import 'package:pingre/features/recurring/services/recurring.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/common/widgets/inputs/search_add.dart';
import 'package:provider/provider.dart';

class RecurringPage extends StatefulWidget {
  const RecurringPage({super.key});

  @override
  State<RecurringPage> createState() => _RecurringPageState();
}

class _RecurringPageState extends State<RecurringPage> {
  final TextEditingController _controller = TextEditingController();

  void _addRecurring(String name) {
    showRecurringTransactionEdit(context, name: name);
  }

  @override
  Widget build(BuildContext context) => Column(
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

                return filteredRecurring.isEmpty
                    ? const Center(
                        child: Text('No recurring transactions found'),
                      )
                    : FTileGroup(
                        divider: .full,
                        children: filteredRecurring
                            .map(
                              (recurring) => FTile(
                                prefix: TimeRangeIcon(unit: recurring.range),
                                title: Text(recurring.name),
                                subtitle: Text(
                                  recurring.transaction.tags.all
                                      .map((t) => t.name)
                                      .join(", "),
                                ),
                                details: ValueDisplay(
                                  value: recurring.transaction.value,
                                ),
                                suffix: const Icon(FIcons.chevronRight),
                                onPress: () => showRecurringTransactionEdit(context, recurringTransaction: recurring),
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
