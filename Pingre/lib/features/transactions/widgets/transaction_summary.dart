import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/features/tags/widgets/tags_display.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/screens/overlay_transaction_detail.dart';

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
          borderRadius: context.theme.style.borderRadius,
        ),
        padding: const .all(6),
        child: child!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: TagsDisplayText(selection: transaction.tags),
                ),
              ),
              SizedBox(width: 4),
              ValueDisplay(value: transaction.value),
            ],
          ),
          if (transaction.notes.isEmpty == false)
            Padding(
              padding: .only(top: 4),
              child: Text(
                style: context.theme.typography.xs,
                transaction.notes,
              ),
            ),
        ],
      ),
      onPress: () => showTransactionDetail(context, transaction: transaction),
    );
  }
}
