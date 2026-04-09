import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// A transaction tag.
class Tag {
  final String id;
  final String name;
  Color? color;
  /// When is the last time the tag has been used.
  DateTime updatedAt;

  Tag({required this.name, this.color, String? id})
    : id = id ?? const Uuid().v4(),
      updatedAt = DateTime.now();

  Tag copyWith({String? name, Color? color}) {
    return Tag(id: id, name: name ?? this.name, color: color ?? this.color);
  }
}
