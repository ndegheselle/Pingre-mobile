import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/data/value_display.dart';

/// A generic widget that displays a single transaction row,
/// matching the style used in the transactions page.
class TransactionSummary extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onPress;

  const TransactionSummary({
    super.key,
    required this.transaction,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return FItem(
      style: FItemStyle.delta(margin: EdgeInsetsGeometry.value(EdgeInsets.zero)),
      title: Row(
        children: [
          Text(transaction.tags.primary.name),
          const SizedBox(width: 8),
          Opacity(
            opacity: 0.5,
            child: Text(
              transaction.tags.secondaries.map((t) => t.name).join(', '),
            ),
          ),
        ],
      ),
      subtitle: transaction.notes.isNotEmpty ? Text(transaction.notes) : null,
      suffix: ValueDisplay(value: transaction.value),
      onPress: onPress,
    );
  }
}
