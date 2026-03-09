import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/models/transaction_group.dart';
import 'package:pingre/screens/transactions/edit/transaction_edit.dart';
import 'package:pingre/screens/transactions/value_display.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/time_range_select.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionssPageState();
}

class _TransactionssPageState extends State<TransactionsPage> {
  TimeRangeUnit _selectedTimeRange = TimeRangeUnit.month;
  late Future<List<Object>> _future;

  @override
  void initState() {
    super.initState();
    final service = context.read<TransactionsService>();
    _future = _loadTransactions(_selectedTimeRange, service);

    service.addListener(_reload);
  }

  @override
  void dispose() {
    context.read<TransactionsService>().removeListener(_reload);
    super.dispose();
  }

  void _reload() {
    final service = context.read<TransactionsService>();
    setState(() {
      _future = _loadTransactions(_selectedTimeRange, service);
    });
  }

  Future<List<Object>> _loadTransactions(
    TimeRangeUnit range,
    TransactionsService service,
  ) async {
    var groups = TransactionGroup.empty(range);
    var transactions = await service.getByRange(groups.range());
    groups.fill(transactions);
    return _flatenGroups(groups);
  }

  List<Object> _flatenGroups(List<TransactionGroup> groups) {
    List<Object> flatItems = [];
    for (final group in groups) {
      flatItems.add(group); // header
      flatItems.addAll(group.transactions); // individual rows
    }
    return flatItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TimeRangeSelect(
          value: _selectedTimeRange,
          onChanged: (range) {
            _selectedTimeRange = range;
            _reload();
          },
        ),
        SizedBox(height: 4),
        Expanded(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return FCircularProgress();
              final flatItems = snapshot.data!;

              return ListView.builder(
                itemCount: flatItems.length,
                itemBuilder: (context, index) {
                  final item = flatItems[index];

                  if (item is TransactionGroup) {
                    return Column(
                      children: [
                        FTile(
                          style: .delta(
                            contentStyle: .delta(padding: .value(.all(8))),
                          ),
                          prefix: const Icon(FIcons.calendar),
                          title: Text(item.name),
                          suffix: ValueDisplay(
                            value: item.total,
                            isHeader: true,
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    );
                  }

                  if (item is Transaction) {
                    final isLast =
                        index == flatItems.length - 1 ||
                        flatItems[index + 1] is TransactionGroup;
                    return Column(
                      children: [
                        FItem(
                          style: .delta(margin: .value(.all(0))),
                          title: Text(item.tags.primary.name),
                          subtitle: Text(
                            item.tags.secondaries.map((t) => t.name).join(", "),
                          ),
                          suffix: ValueDisplay(value: item.value),
                          onPress: () =>
                              showTransactionEdit(context, transaction: item),
                        ),
                        if (isLast) SizedBox(height: 4),
                      ],
                    );
                  }

                  return SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
