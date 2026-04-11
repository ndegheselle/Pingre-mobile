import 'package:flutter/material.dart' hide Table, Column;
import 'package:drift/drift.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/tags/models/tag.dart';

class TagsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get color => integer().nullable()(); // store Color as ARGB int
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

extension TagMapper on Tag {
  // Domain → DB row
  TagsTableData toData() => TagsTableData(
    id: id,
    name: name,
    color: color?.toARGB32(),
    updatedAt: updatedAt,
  );

  // DB row → Domain model
  static Tag fromData(TagsTableData data) {
    final tag = Tag(
      id: data.id,
      name: data.name,
      color: data.color != null ? Color(data.color!) : null,
    );
    tag.updatedAt = data.updatedAt;
    return tag;
  }
}
