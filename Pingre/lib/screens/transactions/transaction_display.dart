import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tags_display.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/theme_extensions.dart';

class TransactionDisplay extends StatelessWidget {
  final Transaction transaction;

  const TransactionDisplay({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TagsDisplay(selection: transaction.tags, alignement: .start),
        ),
        Text(
          transaction.value.toStringAsFixed(2),
          style: context.theme.typography.base.copyWith(
            fontWeight: .bold,
            color: transaction.value <= 0
                ? context.theme.semantic.negative
                : context.theme.semantic.positive,
          ),
        ),
      ],
    );
  }
}
