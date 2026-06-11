import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/features/tags/widgets/tags_display.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/screens/overlay_transaction_edit.dart';

/// A generic widget that displays a single transaction row,
/// matching the style used in the transactions page.
class TransactionSummary extends StatelessWidget {
  final Transaction transaction;

  const TransactionSummary({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return FTappable(
      builder: (context, states, child) => Container(
        decoration: BoxDecoration(
          color:
              (states.contains(FTappableVariant.hovered) ||
                  states.contains(FTappableVariant.pressed))
              ? context.theme.colors.secondary
              : context.theme.colors.background,
          borderRadius: context.theme.style.borderRadius.md,
        ),
        padding: const .symmetric(horizontal: 10),
        child: child!,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: TagsDisplayText(selection: transaction.tags),
                ),
                if (transaction.notes.isEmpty == false)
                  Text(
                    style: context.theme.typography.xs2,
                    transaction.notes,
                  ),
              ],
            ),
          ),
          ValueDisplay(value: transaction.value),
        ],
      ),
      onPress: () => showTransactionEdit(context, transaction: transaction),
    );
  }
}
