import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/theme_extensions.dart';

class ValueInput extends StatefulWidget {
  const ValueInput({super.key});

  @override
  State<ValueInput> createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
  bool _isMinus = true;

  @override
  Widget build(BuildContext context) {
    final color = _isMinus
        ? context.theme.semantic.negative
        : context.theme.semantic.positive;

    return Row(
      children: [
        FButton.icon(
          variant: .ghost,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Icon(
              _isMinus ? FIcons.minus : FIcons.plus,
              key: ValueKey(_isMinus), // IMPORTANT
              size: 28,
              color: color,
            ),
          ),
          onPress: () {
            setState(() {
              _isMinus = !_isMinus;
            });
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FTextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              maxLines: 1,
              style: .delta(
                contentTextStyle: .delta([
                  .base(
                    .delta(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
        Icon(FIcons.euro, size: 28, color: color),
      ],
    );
  }
}
