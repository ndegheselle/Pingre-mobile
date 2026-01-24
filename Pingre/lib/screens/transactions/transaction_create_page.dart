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
                child: const Icon(FIcons.plus),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: FButton(
                style: FButtonStyle.ghost(),
                onPress: () => Navigator.pop(context),
                child: const Icon(FIcons.x),
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
              borderRadius:
                  theme.style.borderRadius, // Adjust the radius for roundness
            ),
            child: Padding(
              padding: EdgeInsets.all(80),
              child: FTextField(
                keyboardType: TextInputType.number,
                maxLines: 1,
                style: (style) => style.copyWith(
                  contentTextStyle: style.contentTextStyle.map(
                    (textStyle) => theme.typography.xl4,
                  ),
                  hintTextStyle: style.hintTextStyle.map(
                    (textStyle) => theme.typography.xl4,
                  ),
                  border: FWidgetStateMap({
                    WidgetState.any: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}