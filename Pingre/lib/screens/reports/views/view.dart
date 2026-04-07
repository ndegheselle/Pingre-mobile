import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';

class TagTotal {
  final Tag tag;
  final Decimal total;

  TagTotal({required this.tag, required this.total});
}

const List<Color> palette = [
  Color(0xFF6366F1),
  Color(0xFF8B5CF6),
  Color(0xFFEC4899),
  Color(0xFFF97316),
  Color(0xFF14B8A6),
  Color(0xFF06B6D4),
  Color(0xFF84CC16),
  Color(0xFFEAB308),
  Color(0xFFEF4444),
  Color(0xFF3B82F6),
];

class TagGraphBar extends StatelessWidget {
  final List<TagTotal> tagTotals;
  final Decimal grandTotal;

  const TagGraphBar({super.key, required this.tagTotals, required this.grandTotal});

  @override
  Widget build(BuildContext context) {
    final absTotal = grandTotal.abs();
    return ClipRRect(
      borderRadius: context.theme.style.borderRadius,
      child: SizedBox(
        height: 24,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          spacing: 2,
          children: tagTotals.map((t) {
            final pct = absTotal > Decimal.zero
                ? t.total.abs().toDouble() / absTotal.toDouble()
                : 1.0 / tagTotals.length;
            return Expanded(
              flex: max(1, (pct * 1000).round()),
              child: Container(color: t.tag.color),
            );
          }).toList(),
        ),
      ),
    );
  }
}
