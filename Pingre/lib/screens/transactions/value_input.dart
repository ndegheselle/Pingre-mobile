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
        const Icon(FIcons.minus, size: 28),
        Expanded(
          child: Padding(
            padding: .symmetric(horizontal: 8),
            child: FTextField(
              textAlign: .right,
              keyboardType: TextInputType.number,
              maxLines: 1,
            ),
          ),
        ),
        const Icon(FIcons.euro, size: 28)
      ],
    );
  }
}
