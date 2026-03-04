import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/theme_extensions.dart';

class NumberValueController extends ValueNotifier<double> {
  NumberValueController([super.initialValue = 0]);

  bool get isNegative => value < 0;
  double get absolute => value.abs();
  String get formatted => absolute.toStringAsFixed(2);

  void setValue(double newValue) {
    value = newValue;
  }

  void setAbsolute(double newValue) {
    value = isNegative ? -newValue : newValue;
  }

  void toggleSign() {
    value = -value;
  }

  void setNegative(bool negative) {
    value = negative ? -absolute : absolute;
  }
}

class ValueInput extends StatefulWidget {
  final NumberValueController controller;

  const ValueInput({super.key, required this.controller});

  @override
  State<ValueInput> createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
  void _onTextChanged(String text) {
    final value = double.tryParse(text);
    if (value != null) {
      widget.controller.setAbsolute(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.controller.isNegative
        ? context.theme.semantic.negative
        : context.theme.semantic.positive;

    return Row(
      children: [
        SizedBox(
          width: 48,
          child: FButton.icon(
            variant: .ghost,
            onPress: widget.controller.toggleSign,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Icon(
                widget.controller.isNegative ? FIcons.minus : FIcons.plus,
                size: 28,
                color: color,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FTextField(
              control: .managed(
                initial: TextEditingValue(text: widget.controller.formatted),
                onChange: (val) => _onTextChanged(val.text),
              ),
              autofocus: true,
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
        SizedBox(width: 48, child: Icon(FIcons.euro, size: 28, color: color)),
      ],
    );
  }
}
