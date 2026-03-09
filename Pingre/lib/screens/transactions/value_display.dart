import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/theme_extensions.dart';

class ValueDisplay extends StatelessWidget {
  final Decimal value;
  final bool isHeader;

  const ValueDisplay({super.key, required this.value, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    var color = value < .zero
        ? context.theme.semantic.negative
        : context.theme.semantic.positive;
    return Row(
      mainAxisSize: .min,
      children: [
        Icon(
          value < .zero ? FIcons.minus : FIcons.plus,
          color: color,
          size: 12,
          fontWeight: isHeader ? .bold : .normal,
        ),
        SizedBox(width: 2),
        Text(
          value.abs().toStringAsFixed(2),
          style: context.theme.typography.base.copyWith(
            color: color,
            fontWeight: isHeader ? .bold : .normal,
          ),
        ),
        SizedBox(width: 2),
        Icon(
          FIcons.euro,
          color: color,
          size: 14,
          fontWeight: isHeader ? .bold : .normal,
        ),
      ],
    );
  }
}