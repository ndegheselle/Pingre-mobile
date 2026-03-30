import 'package:pingre/models/time_range.dart';
import 'package:pingre/services/transactions.dart';
import 'package:uuid/uuid.dart';

class RecurringTransaction {
  final String id;
  final Transaction transaction;
  final TimeRangeUnit range;

  RecurringTransaction({
    required this.transaction,
    required this.range,
    String? id,
  }) : id = id ?? const Uuid().v4();

  RecurringTransaction copyWith({
    String? id,
    Transaction? transaction,
    TimeRangeUnit? range,
  }) {
    return RecurringTransaction(
      id: id ?? this.id,
      transaction: transaction ?? this.transaction,
      range: range ?? this.range,
    );
  }
}