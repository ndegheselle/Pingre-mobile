import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/models/transaction_group.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/theme_extensions.dart';
import 'package:pingre/widgets/time_range_select.dart';
import 'package:provider/provider.dart';

class ValueDisplay extends StatelessWidget {
  final Decimal value;

  const ValueDisplay({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    var color = value < .zero
        ? context.theme.semantic.negative
        : context.theme.semantic.positive;
    return Row(
      mainAxisSize: .min,
      children: [
        Icon(
          value < .zero ? FIcons.minus : FIcons.plus,
          color: color,
          size: 12,
        ),
        SizedBox(width: 2),
        Text(
          value.toStringAsFixed(2),
          style: context.theme.typography.base.copyWith(color: color),
        ),
        SizedBox(width: 2),
        Icon(FIcons.euro, color: color, size: 14),
      ],
    );
  }
}

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionssPageState();
}

class _TransactionssPageState extends State<TransactionsPage> {
  List<TransactionGroup> _groups = [];

  void _onTimeRangeChanged(TimeRangeUnit range) async {
    var groups = TransactionGroup.empty(range);
    var service = Provider.of<TransactionsService>(context, listen: false);
    var transactions = await service.getByRange(groups.range());
    groups.fill(transactions);

    setState(() {
      _groups = groups;
    });
  }

  List<Object> get _flatItems {
    final items = <Object>[];
    for (final group in _groups) {
      items.add(group); // header
      items.addAll(group.transactions); // individual rows
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _flatItems;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TimeRangeSelect(
          value: TimeRangeUnit.month,
          onChanged: _onTimeRangeChanged,
        ),
        SizedBox(height: 4),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              if (item is TransactionGroup) {
                return Column(
                  children: [
                    FTile(
                      style: .delta(
                        contentStyle: .delta(
                          padding: .value(.all(8)),
                        ),
                      ),
                      prefix: const Icon(FIcons.calendar),
                      title: Text(item.name),
                      suffix: ValueDisplay(value: item.total),
                    ),
                    SizedBox(height: 4),
                  ],
                );
              }

              if (item is Transaction) {
                final isLast =
                    index == items.length - 1 ||
                    items[index + 1] is TransactionGroup;
                return Column(
                  children: [
                    FTile(
                      style: .delta(
                        contentStyle: .delta(
                          padding: .value(
                            .symmetric(horizontal: 8, vertical: 6),
                          ),
                        ),
                      ),
                      title: Text(item.tags.primary.name),
                      subtitle: Text(
                        item.tags.secondaries.map((t) => t.name).join(", "),
                      ),
                      suffix: Opacity(
                        opacity: 0.6,
                        child: ValueDisplay(value: item.value),
                      ),
                      onPress: () {},
                    ),
                    if (isLast) SizedBox(height: 4),
                  ],
                );
              }

              return SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
