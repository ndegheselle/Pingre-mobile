import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Tag {
  final String id;
  final String name;
  final Color? color;

  Tag({required this.name, this.color, String? id})
    : id = id ?? const Uuid().v4();

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

  void addTag(Tag tag) {
    if (_tags.any((t) => t.name == tag.name)) {
      return;
    }

    _tags.add(tag);
    notifyListeners();
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
