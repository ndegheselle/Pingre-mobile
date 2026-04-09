
import 'package:decimal/decimal.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/transactions/models/transaction.dart';

/// A group of transactions
class TransactionsGroup {
  final TimeRange range;
  final String name;
  final Decimal total;
  final List<Transaction> transactions;

  TransactionsGroup({
    required this.range,
    required this.name,
    required this.transactions,
  }) : total = transactions.fold(.zero, (a, b) => a + b.value);
}
