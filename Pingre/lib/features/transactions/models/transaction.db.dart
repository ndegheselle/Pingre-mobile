import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:pingre/features/transactions/models/transaction.dart';

class TransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get value => text()(); // store Decimal as string
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Junction table linking transactions to their tags.
/// [isPrimary] marks the one tag acting as the category.
class TransactionTagsTable extends Table {
  TextColumn get transactionId => text()();
  TextColumn get tagId => text()();
  BoolColumn get isPrimary => boolean()();

  @override
  Set<Column> get primaryKey => {transactionId, tagId};
}

extension TransactionMapper on Transaction {
  // Domain → DB row
  TransactionsTableData toData() => TransactionsTableData(
    id: id,
    value: value.toString(),
    date: date,
    notes: notes,
  );

  // DB row → Domain model (tags resolved separately via TransactionTagsTable)
  static Transaction fromData(TransactionsTableData data, TagsSelection tags) =>
      Transaction(
        id: data.id,
        value: Decimal.parse(data.value),
        date: data.date,
        notes: data.notes,
        tags: tags,
      );
}
