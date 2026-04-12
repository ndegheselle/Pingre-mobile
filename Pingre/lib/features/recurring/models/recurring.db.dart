import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/recurring/models/recurring.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:pingre/features/transactions/models/transaction.dart';

/// The recurring rule itself plus its embedded transaction template stored inline.
class RecurringTransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get range => text()(); // store TimeRangeUnit as string

  // Embedded transaction template fields
  TextColumn get transactionId => text()();
  TextColumn get transactionValue => text()(); // store Decimal as string
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get transactionNotes => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Junction table linking a recurring transaction's template to its tags.
/// [isPrimary] marks the one tag acting as the category.
class RecurringTransactionTagsTable extends Table {
  TextColumn get recurringTransactionId => text()();
  TextColumn get tagId => text()();
  BoolColumn get isPrimary => boolean()();

  @override
  Set<Column> get primaryKey => {recurringTransactionId, tagId};
}

extension RecurringTransactionMapper on RecurringTransaction {
  // Domain → DB row
  RecurringTransactionsTableData toData() => RecurringTransactionsTableData(
    id: id,
    name: name,
    range: range.name, // enum → string
    isActive: isActive,
    transactionId: transaction.id,
    transactionValue: transaction.value.toString(),
    transactionDate: transaction.date,
    transactionNotes: transaction.notes,
  );

  // DB row → Domain model (tags resolved separately via RecurringTransactionTagsTable)
  static RecurringTransaction fromData(
    RecurringTransactionsTableData data,
    TagsSelection tags,
  ) => RecurringTransaction(
    id: data.id,
    name: data.name,
    range: TimeRangeUnit.values.byName(data.range),
    isActive: data.isActive,
    transaction: Transaction(
      id: data.transactionId,
      value: Decimal.parse(data.transactionValue),
      date: data.transactionDate,
      notes: data.transactionNotes,
      tags: tags,
    ),
  );
}
