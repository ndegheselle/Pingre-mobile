import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/theme_extensions.dart';

class ValueDisplay extends StatelessWidget {
  final Decimal value;
  final bool isHeader;

  const ValueDisplay({super.key, required this.value, this.isHeader = false});

  String _formatValue(Decimal value) {
    final abs = value.abs();
    final doubleVal = abs.toDouble();

    if (doubleVal >= 1000000) {
      final m = doubleVal / 1000000;
      return '${_trimTrailingZeros(m.toStringAsFixed(2))}M';
    } else if (doubleVal >= 1000) {
      final k = doubleVal / 1000;
      return '${_trimTrailingZeros(k.toStringAsFixed(2))}K';
    }

    return abs.toStringAsFixed(2);
  }

  String _trimTrailingZeros(String value) {
    if (!value.contains('.')) return value;
    value = value.replaceAll(RegExp(r'0+$'), '');
    if (value.endsWith('.')) value = value.substring(0, value.length - 1);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    var color = value < Decimal.zero
        ? context.theme.semantic.negative
        : context.theme.semantic.positive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          value < Decimal.zero ? FIcons.minus : FIcons.plus,
          color: color,
          size: 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
        const SizedBox(width: 2),
        Text(
          _formatValue(value),
          style: context.theme.typography.base.copyWith(
            color: color,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            height: 1.3,
          ),
        ),
        const SizedBox(width: 2),
        Icon(
          FIcons.euro,
          color: color,
          size: 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }
}