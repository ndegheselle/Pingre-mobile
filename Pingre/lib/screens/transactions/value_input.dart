import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ValueInput extends StatefulWidget {
  const ValueInput({super.key});

  @override
  State<ValueInput> createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Row(
      children: [
        const Text(
          "-",
          style: TextStyle(
            fontSize: 24, // Bigger font size
            fontWeight: .bold, // Bold text
          ),
        ),
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
    );
  }
}
