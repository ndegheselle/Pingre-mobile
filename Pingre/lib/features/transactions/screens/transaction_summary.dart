import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/transactions/screens/transaction_detail.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/common/widgets/data/value_display.dart';

/// A generic widget that displays a single transaction row,
/// matching the style used in the transactions page.
class TransactionSummary extends StatelessWidget {
  final Transaction transaction;

  const TransactionSummary({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return FItem(
      style: .delta(margin: .value(EdgeInsets.zero)),
      title: Row(children: [Text(transaction.tags.primary.name)]),
      subtitle: transaction.tags.secondaries.isNotEmpty
          ? Text(transaction.tags.secondaries.map((t) => t.name).join(', '))
          : null,
      suffix: ValueDisplay(value: transaction.value),
      onPress: () => showTransactionDetail(context, transaction: transaction),
    );
  }
}
