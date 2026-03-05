import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/tags.dart';
import 'package:provider/provider.dart';

class TagsDisplay extends StatelessWidget {
  final Set<String> tagIds;

  const TagsDisplay({super.key, required this.tagIds});

  @override
  Widget build(BuildContext context) {
    return Consumer<TagsService>(
      builder: (context, service, child) {
        // Filtrer les tags en fonction des IDs fournis
        final tags = service.tags
            .where((tag) => tagIds.contains(tag.id))
            .toList();

        if (tags.isEmpty) {
          return const Center(
            child: Opacity(opacity: 0.5, child: Text("Aucun tag sélectionné")),
          );
        }

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 2,
          runSpacing: 4,
          children: tags.map((tag) {
            return FBadge(variant: .outline, child: Text(tag.name));
          }).toList(),
        );
      },
    );
  }
}
