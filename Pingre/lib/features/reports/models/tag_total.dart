import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pingre/features/tags/models/tag.dart';

class TagTotal {
  final Tag tag;
  final Decimal total;
  final Decimal previousAverage;

  double get percentageDifference => previousAverage == Decimal.zero
      ? 0
      : (((total - previousAverage) / previousAverage).toDecimal(
                  scaleOnInfinitePrecision: 2,
                ) *
                Decimal.fromInt(100))
            .toDouble();

  TagTotal({
    required this.tag,
    required this.total,
    required this.previousAverage,
  });
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
