import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:uuid/uuid.dart';

class RecurringTransaction {
  final String id;
  final String name;
  final Transaction transaction;
  final TimeRangeUnit range;

  RecurringTransaction({
    required this.name,
    required this.transaction,
    required this.range,
    String? id
  }) : id = id ?? const Uuid().v4();

  RecurringTransaction copyWith({
    String? id,
    String? name,
    Transaction? transaction,
    TimeRangeUnit? range,
    bool? isActive,
  }) {
    return RecurringTransaction(
      id: id ?? this.id,
      name: name ?? this.name,
      transaction: transaction ?? this.transaction,
      range: range ?? this.range,
    );
  }
}
