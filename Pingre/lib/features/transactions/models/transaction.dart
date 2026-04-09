import 'package:decimal/decimal.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:uuid/uuid.dart';

/// One line of transaction
class Transaction {
  final String id;
  final Decimal value;

  final TagsSelection tags;

  final DateTime date;
  final String notes;

  Transaction({
    required this.value,
    required this.date,
    required this.tags,
    this.notes = "",
    String? id,
  }) : id = id ?? const Uuid().v4();

  Transaction copyWith({
    Decimal? value,
    TagsSelection? tags,
    DateTime? date,
    String? notes,
  }) {
    return Transaction(
      id: id,
      value: value ?? this.value,
      tags: tags ?? this.tags,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}