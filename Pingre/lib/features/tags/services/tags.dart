import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/tags/models/tag.dart';
import 'package:pingre/features/tags/models/tag.db.dart';

class TagsService extends ChangeNotifier {
  final AppDatabase _db;

  /// In-memory cache — kept in sync with the DB on every mutation.
  final Map<String, Tag> tagsMap = {};
  Iterable<Tag> get tags => tagsMap.values;

  TagsService(this._db);

  Future<void> initialize() async {
    final rows = await _db.select(_db.tagsTable).get();
    tagsMap.clear();
    for (final row in rows) {
      tagsMap[row.id] = TagMapper.fromData(row);
    }
    notifyListeners();
  }

  Future<Tag> _addTag(Tag tag) async {
    await _db.into(_db.tagsTable).insert(tag.toData());
    tagsMap[tag.id] = tag;
    notifyListeners();
    return tag;
  }

  /// Returns the existing tag with [name] (case-insensitive), or creates one.
  Future<Tag> getOrCreate(String name) async {
    final cleanedName = name.trim();
    final existing = tags.firstWhereOrNull(
      (t) => t.name.toLowerCase() == cleanedName.toLowerCase(),
    );
    return existing ?? await _addTag(Tag(name: cleanedName));
  }

  Future<Tag> createIfMissing(String name) => getOrCreate(name);

  Iterable<Tag> search(String name) {
    return tags.where(
      (t) => t.name.toLowerCase().contains(name.trim().toLowerCase()),
    );
  }

  Tag? getTagById(String id) => tagsMap[id];

  Future<void> update(String id, {String? name, Color? color}) async {
    if (!tagsMap.containsKey(id)) return;
    final updated = tagsMap[id]!.copyWith(name: name, color: color);
    await _db.update(_db.tagsTable).replace(updated.toData());
    tagsMap[id] = updated;
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await (_db.delete(_db.tagsTable)..where((t) => t.id.equals(id))).go();
    tagsMap.remove(id);
    notifyListeners();
  }
}
