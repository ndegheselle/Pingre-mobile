import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:pingre/l10n/app_localizations.dart';

class TagsDisplay extends StatelessWidget {
  final TagsSelection? selection;
  final WrapAlignment? alignement;
  final bool wrap;

  const TagsDisplay({super.key, required this.selection, this.alignement, this.wrap = true});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (selection == null) {
      return Center(
        child: Opacity(opacity: 0.5, child: Text(l10n.noTags)),
      );
    }

    final badges = [
      FBadge(child: Text(selection!.primary.name)),
      ...selection!.secondaries.map((tag) => FBadge(variant: .secondary, child: Text(tag.name))),
    ];

    if (!wrap) {
      return ClipRect(
        child: Row(
          mainAxisSize: .min,
          spacing: 2,
          children: badges,
        ),
      );
    }

    return Wrap(
      alignment: alignement ?? WrapAlignment.center,
      spacing: 2,
      runSpacing: 4,
      children: badges,
    );
  }
}

class TagsDisplayText extends StatelessWidget {
  final TagsSelection? selection;

  const TagsDisplayText({super.key, required this.selection});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (selection == null) {
      return Center(
        child: Opacity(opacity: 0.5, child: Text(l10n.noTags)),
      );
    }
    return Text(selection!.all.map((t) => t.name).join(', '));
  }
}