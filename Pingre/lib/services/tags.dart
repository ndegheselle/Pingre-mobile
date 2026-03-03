import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Tag {
  final String id;
  final String name;
  final Color? color;
  DateTime updatedAt;

  Tag({required this.name, this.color, String? id})
    : id = id ?? const Uuid().v4(), updatedAt = DateTime.now();

  Tag copyWith({String? name, Color? color}) {
    return Tag(
      id: id, // preserve the same id
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}

class TagsService extends ChangeNotifier {
  final List<Tag> _tags = [];

  List<Tag> get tags => List.unmodifiable(_tags);

  Tag _addTag(Tag tag) {
    _tags.add(tag);
    notifyListeners();
    return tag;
  }

  Tag getOrCreate(String name) {
    return search(name) ?? _addTag(Tag(name: name.trim()));
  }

  Tag? search(String name) {
    return _tags.firstWhereOrNull(
      (t) => t.name.toLowerCase() == name.trim().toLowerCase(),
    );
  }

  void updateTag(String id, {String? name, Color? color}) {
    final index = _tags.indexWhere((tag) => tag.id == id);
    if (index == -1) return;

    _tags[index] = _tags[index].copyWith(name: name, color: color);
    notifyListeners();
  }

  void removeTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    notifyListeners();
  }
}
