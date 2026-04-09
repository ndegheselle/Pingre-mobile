import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:pingre/l10n/app_localizations.dart';

class TagsDisplay extends StatelessWidget {
  final TagsSelection? selection;
  final WrapAlignment? alignement;

  const TagsDisplay({super.key, required this.selection, this.alignement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (selection == null) {
      return Center(
        child: Opacity(opacity: 0.5, child: Text(l10n.noTags)),
      );
    }

    return Wrap(
      alignment: alignement ?? WrapAlignment.center,
      spacing: 2,
      runSpacing: 4,
      children: [ FBadge(variant: .android, child: Text(selection!.primary.name)),
      ...selection!.secondaries.map((tag) {
        return FBadge(variant: .outline, child: Text(tag.name));
      })]
    );
  }
}
