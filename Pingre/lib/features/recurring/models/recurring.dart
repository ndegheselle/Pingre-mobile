import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:uuid/uuid.dart';

class RecurringTransaction {
  final String id;
  final String name;
  final Transaction transaction;
  final TimeRangeUnit range;
  final bool isActive;

  RecurringTransaction({
    required this.name,
    required this.transaction,
    required this.range,
    String? id,
    bool? isActive,
  }) : id = id ?? const Uuid().v4(),
       isActive = isActive ?? true;

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
      isActive: isActive ?? this.isActive,
    );
  }
}
