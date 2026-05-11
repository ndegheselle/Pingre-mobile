import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/transaction_group.dart';
import 'package:pingre/common/widgets/data/value_display.dart';

/// A generic widget that displays a single transaction row,
/// matching the style used in the transactions page.
class GroupSummary extends StatelessWidget {
  final TransactionGroup group;
  final double? height;

  const GroupSummary({super.key, required this.group, this.height});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Container(
      height: height,
      margin: .symmetric(vertical: 2),
      padding: .symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: context.theme.colors.card,
        borderRadius: context.theme.style.borderRadius.md,
        border: .all(
          color: context.theme.colors.border,
          width: context.theme.style.borderWidth,
        ),
      ),
      child: Row(
        children: [
          const Icon(FIcons.calendar),
          const SizedBox(width: 6),
          Text(group.getName(locale)),
          const Spacer(),
          ValueDisplay(value: group.total, isHeader: true),
        ],
      ),
    );
  }
}
