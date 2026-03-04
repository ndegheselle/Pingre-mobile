import 'package:uuid/uuid.dart';

class Transaction {
  final String id;
  final double value;
  final Set<String> tagsId;
  final DateTime date;
  final String notes;

  Transaction({
    required this.value,
    required this.date,
    this.tagsId = const {},
    this.notes = "",
    String? id,
  }) : id = id ?? const Uuid().v4();
}