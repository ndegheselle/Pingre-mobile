import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// A transaction tag.
class Tag {
  final String id;
  final String name;
  final Color? color;
  /// When is the last time the tag has been used.
  DateTime updatedAt;

  Tag({required this.name, this.color, String? id})
    : id = id ?? const Uuid().v4(),
      updatedAt = DateTime.now();

  Tag copyWith({String? name, Color? color}) {
    return Tag(id: id, name: name ?? this.name, color: color ?? this.color);
  }
}

class TagsService extends ChangeNotifier {
  final Map<String, Tag> tagsMap = {};
  Iterable<Tag> get tags => tagsMap.values;

  TagsService() {
    // Initialize with test tags
    _initializeTestTags();
  }

  void _initializeTestTags() {
    List<String> testTagNames = [
      'Urgent',
      'Work',
      'Personal',
      'Shopping',
      'Travel',
      'Health',
      'Fitness',
      'Study',
      'Meeting',
      'Family',
      'Friends',
      'Hobby',
      'Food',
      'Music',
      'Books',
      'Movies',
      'Sports',
      'Finance',
      'Project',
      'Ideas',
    ];

    for (var name in testTagNames) {
      createIfMissing(name);
    }
  }

  Tag _addTag(Tag tag) {
    tagsMap[tag.id] = tag;
    notifyListeners();
    return tag;
  }

  /// Create the tag if no tag of the [name] exist, return the existing or created tag.
  Tag getOrCreate(String name) {
    String cleanedName = name.trim();
    var tag = tags.firstWhereOrNull(
      (t) => t.name.toLowerCase() == cleanedName.toLowerCase(),
    );

    return tag ?? _addTag(Tag(name: cleanedName));
  }

  /// Create a tag if it doesn't exist.
  Tag createIfMissing(String name) {
    return getOrCreate(name);
  }

  Iterable<Tag> search(String name) {
    return tags.where((t) => t.name.toLowerCase().contains(name.trim().toLowerCase()));
  }

  Tag? getTagById(String id) {
    return tagsMap[id];
  }

  void update(String id, {String? name, Color? color}) {
    if (!tagsMap.containsKey(id)) return;

    tagsMap[id] = tagsMap[id]!.copyWith(name: name, color: color);
    notifyListeners();
  }

  void remove(String id) {
    tagsMap.remove(id);
    notifyListeners();
  }
}
