import 'package:pingre/features/tags/models/tag.dart';

/// A selection of tags, a [primary] tag act like a category and is used to group and create reports
class TagsSelection {
  /// Main tag of the selection
  final Tag primary;

  /// Secondaries tags
  final List<Tag> secondaries;
  List<Tag> get all => [primary, ...secondaries];

  TagsSelection({required this.primary, List<Tag>? secondaries})
    : secondaries = secondaries ?? [];
}
