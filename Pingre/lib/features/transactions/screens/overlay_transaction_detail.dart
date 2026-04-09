import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/tags/widgets/tags_display.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/screens/overlay_transaction_edit.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/common/widgets/layout/sheet_container.dart';
import 'package:pingre/l10n/app_localizations.dart';

Future<dynamic> showTransactionDetail(
  BuildContext context, {
  required Transaction transaction,
}) {
  return showFSheet(
    mainAxisMaxRatio: 5 / 10,
    context: context,
    side: .btt,
    builder: (context) => OverlayTransactionDetail(transaction: transaction),
  );
}

class OverlayTransactionDetail extends StatelessWidget {
  final Transaction transaction;

  const OverlayTransactionDetail({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return SheetContainer(
      title: l10n.transactionDetailTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueDisplay(value: transaction.value, isHeader: true),
          const SizedBox(height: 4),
          Text(transaction.date.formatWithHour(locale)),
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
          FButton(
            onPress: () {
              Navigator.of(context).pop();
              showTransactionEdit(context, transaction: transaction);
            },
            prefix: const Icon(FIcons.pencil),
            child: Text(l10n.actionEdit),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
