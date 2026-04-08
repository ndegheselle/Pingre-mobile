import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/screens/tags/tags_display.dart';
import 'package:pingre/screens/transactions/transaction_edit.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/data/value_display.dart';
import 'package:pingre/widgets/layout/sheet_container.dart';

Future<dynamic> showTransactionDetail(
  BuildContext context, {
  required Transaction transaction,
}) {
  return showFSheet(
    mainAxisMaxRatio: 5 / 10,
    context: context,
    side: .btt,
    builder: (context) => TransactionDetail(transaction: transaction),
  );
}

class TransactionDetail extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetail({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      title: "Transaction",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueDisplay(value: transaction.value, isHeader: true),
          const SizedBox(height: 4),
          Text(transaction.date.formatWithHour()),
          const SizedBox(height: 4),
          TagsDisplay(selection: transaction.tags),
          const SizedBox(height: 4),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: context.theme.style.borderRadius,
                border: Border.all(color: context.theme.colors.border),
              ),
              child: Padding(
                padding: .symmetric(horizontal: 8, vertical: 4),
                child: SelectableText(transaction.notes),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Tags
          FButton(
            onPress: () {
              Navigator.of(context).pop();
              showTransactionEdit(context, transaction: transaction);
            },
            prefix: const Icon(FIcons.pencil),
            child: const Text("Edit"),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
