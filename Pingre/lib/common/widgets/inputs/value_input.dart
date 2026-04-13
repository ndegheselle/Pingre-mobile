import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/settings/services/settings.dart';
import 'package:pingre/theme_extensions.dart';
import 'package:provider/provider.dart';

class NumberValueController extends ValueNotifier<Decimal> {
  NumberValueController([Decimal? initialValue])
    : super(initialValue ?? Decimal.zero);

  bool get isNegative => value <= .zero;
  Decimal get absolute => value.abs();
  String get formatted => absolute.toStringAsFixed(2);

  void setValue(Decimal newValue) {
    value = newValue;
  }

  void setAbsolute(Decimal newValue) {
    value = isNegative ? -newValue : newValue;
  }

  void toggleSign() {
    value = -value;
  }

  void setNegative(bool negative) {
    value = negative ? -absolute : absolute;
  }
}

/// Decimal value input for a transaction
class ValueInput extends StatefulWidget {
  final NumberValueController controller;
  final bool readonly;

  const ValueInput({
    super.key,
    required this.controller,
    this.readonly = false,
  });

  @override
  State<ValueInput> createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  void _onTextChanged() {
    final value = Decimal.tryParse(_textController.text);
    if (value != null) {
      widget.controller.setAbsolute(value);
    } else {
      _textController.text = widget.controller.formatted;
    }
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.formatted);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _textController.text.length,
        );
      }
    });

    // Listen to changes in the controller
    widget.controller.addListener(_onControllerChanged);
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.controller.removeListener(_onControllerChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    // Trigger a rebuild when the controller's value changes
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.controller.isNegative
        ? context.theme.semantic.negative
        : context.theme.semantic.positive;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          child: FButton.icon(
            variant: .ghost,
            onPress: widget.readonly ? null : widget.controller.toggleSign,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Icon(
                widget.controller.isNegative ? FIcons.minus : FIcons.plus,
                size: 28,
                color: color,
                fontWeight: .bold,
              ),
            ),
          ),
        ),
        Flexible(
          child: IntrinsicWidth(
            child: FTextField(
              control: .managed(controller: _textController, focusNode: _focusNode),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLines: 1,
              enabled: !widget.readonly,
              style: .delta(
                contentPadding: .value(.zero),
                border: FVariants(
                  InputBorder.none,
                  variants: {
                    [.focused]: InputBorder.none,
                    [.disabled]: InputBorder.none,
                    [.error]: InputBorder.none,
                    [.error.and(.disabled)]: InputBorder.none,
                  },
                ),
                contentTextStyle: FVariants(
                  .new(color: color, fontSize: 32, fontWeight: FontWeight.w600),
                  variants: {},
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 48,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              context.read<SettingsService>().currency.icon,
              size: 28,
              color: color,
              fontWeight: .bold,
            ),
          ),
        ),
      ],
    );
  }
}
