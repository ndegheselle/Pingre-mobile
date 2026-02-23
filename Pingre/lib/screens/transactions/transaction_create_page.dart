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

    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
      ),
      child: Padding(
        padding: const .all(8),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text("-",
                  style: TextStyle(
                      fontSize: 24, // Bigger font size
                      fontWeight: .bold, // Bold text
                    )),
                  Expanded(
                    child: Padding(
                      padding: .symmetric(horizontal: 8),
                      child: FTextField(
                        textAlign: .right,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        style: (style) => style.copyWith(
                          contentTextStyle: style.contentTextStyle.map(
                            (textStyle) => theme.typography.xl.copyWith(
                              fontWeight: .bold,
                              height: 1.4,
                            ),
                          ),
                          hintTextStyle: style.hintTextStyle.map(
                            (textStyle) =>
                                theme.typography.xl.copyWith(fontWeight: .bold),
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
                  const Text(
                    "€",
                    style: TextStyle(
                      fontSize: 24, // Bigger font size
                      fontWeight: .bold, // Bold text
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
