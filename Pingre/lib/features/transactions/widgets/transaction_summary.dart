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
                  // Tighten the inherited line height (1.5, top-heavy leading)
                  // and distribute it evenly so the row looks vertically
                  // centered; 1.45 keeps enough ascent for emoji in tag names.
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(
                      height: 1.45,
                      leadingDistribution: .even,
                    ),
                    child: TagsDisplayText(selection: transaction.tags),
                  ),
                ),
                if (transaction.notes.isEmpty == false)
                  Text(
                    // xs2 has height 1, which is smaller than the glyphs
                    // themselves; 1.2 keeps descenders inside the line box.
                    style: context.theme.typography.xs2.copyWith(height: 1.2),
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
