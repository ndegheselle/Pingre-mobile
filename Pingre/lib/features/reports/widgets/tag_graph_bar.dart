import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/reports/models/tag_total.dart';

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
