import 'package:pingre/services/tags.dart';
import 'package:uuid/uuid.dart';

class TagsSelection
{
  final Tag primary;
  final List<Tag> secondaries;

  TagsSelection({required this.primary, List<Tag>? secondaries}) : secondaries = secondaries ?? [];
}

class Transaction {
  final String id;
  final double value;
  
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
}