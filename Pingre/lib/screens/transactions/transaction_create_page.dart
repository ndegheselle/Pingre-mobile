import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/theme/colors.dart';

class TransactionCreatePage extends StatefulWidget {
  const TransactionCreatePage({super.key});

  @override
  State<TransactionCreatePage> createState() => _TransactionCreatePageState();
}

class _TransactionCreatePageState extends State<TransactionCreatePage> {
  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return FScaffold(
      header: FHeader.nested(
        title: const Text('New transaction'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.pop(context))],
      ),
      footer: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: FButton(
                style: FButtonStyle.primary(),
                onPress: () {},
                prefix: const Icon(FIcons.plus),
                child: const Text("Add"),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: FButton(
                style: FButtonStyle.ghost(),
                onPress: () => Navigator.pop(context),
                prefix: const Icon(FIcons.x),
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.colors.success,
              borderRadius: theme.style.borderRadius,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: FTextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: (style) => style.copyWith(
                      contentTextStyle: style.contentTextStyle.map(
                        (textStyle) => theme.typography.xl4.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      border: FWidgetStateMap({
                        WidgetState.any: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      }),
                    ),
                  ),
                ),
                Text(
                  'kg',
                  style: theme.typography.xl4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
