import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/settings/services/settings.dart';
import 'package:pingre/features/tags/screens/page_tags.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  bool _isProcessing = false;

  Future<void> _backup() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final dir = await getApplicationSupportDirectory();
      final dbPath = '${dir.path}/pingre.db.sqlite';
      final savedPath = await FilePicker.platform.saveFile(
        fileName: 'pingre_backup.db',
        allowedExtensions: ['db'],
        type: FileType.custom,
      );
      if (savedPath != null) {
        await File(dbPath).copy(savedPath);
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showFToast(
            context: context,
            alignment: .topCenter,
            icon: const Icon(FIcons.check),
            title: Text(l10n.settingsBackupSuccess),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _restore() async {
    if (_isProcessing) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['sqlite'],
    );
    final filePath = result?.files.single.path;
    if (filePath == null || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: Text(l10n.settingsRestoreDialogTitle),
        body: Text(l10n.settingsRestoreDialogBody),
        actions: [
          FButton(
            variant: .destructive,
            size: .sm,
            child: Text(l10n.actionConfirm),
            onPress: () => Navigator.of(context).pop(true),
          ),
          FButton(
            variant: .outline,
            size: .sm,
            child: Text(l10n.actionCancel),
            onPress: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isProcessing = true);
    final db = context.read<AppDatabase>();
    await db.close();
    final dir = await getApplicationSupportDirectory();
    await File(filePath).copy('${dir.path}/pingre.db.sqlite');
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final l10n = AppLocalizations.of(context)!;

    return FScaffold(
      header: FHeader.nested(
        title: Text(l10n.settingsTitle),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.pop(context))],
      ),
      child: Padding(
        padding: .only(bottom: 12),
        child: Column(
          children: [
            FTileGroup(
              label: Text(l10n.settingsData),
              children: [
                .tile(
                  prefix: const Icon(FIcons.tags),
                  title: Text(l10n.settingsTags),
                  suffix: const Icon(FIcons.chevronRight),
                  details: Text(l10n.settingsTagsDetail),
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const PageTags(),
                      ),
                    );
                  },
                ),
              ],
            ),
            FTileGroup(
              label: Text(l10n.settingsAppearance),
              children: [
                FSelectMenuTile<ThemeMode>(
                  selectControl: .managedRadio(
                    initial: settings.themeMode,
                    onChange: (values) {
                      if (values.isNotEmpty) settings.themeMode = values.first;
                    },
                  ),
                  prefix: const Icon(FIcons.sunMoon),
                  title: Text(l10n.settingsTheme),
                  detailsBuilder: (_, values, _) =>
                      _ThemeSquare(mode: values.firstOrNull ?? .system),
                  menu: [
                    .suffix(
                      prefix: const _ThemeSquare(mode: .system),
                      title: Text(l10n.settingsThemeAuto),
                      value: .system,
                    ),
                    .suffix(
                      prefix: const _ThemeSquare(mode: .light),
                      title: Text(l10n.settingsThemeLight),
                      value: .light,
                    ),
                    .suffix(
                      prefix: const _ThemeSquare(mode: .dark),
                      title: Text(l10n.settingsThemeDark),
                      value: .dark,
                    ),
                  ],
                ),
                FSelectMenuTile<Locale?>(
                  selectControl: .managedRadio(
                    initial: settings.locale,
                    onChange: (values) {
                      if (values.isNotEmpty) settings.locale = values.first;
                    },
                  ),
                  prefix: const Icon(FIcons.languages),
                  title: Text(l10n.settingsLanguage),
                  detailsBuilder: (_, values, _) {
                    final locale = values.firstOrNull;
                    return Text(
                      locale == null
                          ? l10n.settingsLanguageAuto
                          : locale.languageCode == 'fr'
                          ? l10n.settingsLanguageFrench
                          : l10n.settingsLanguageEnglish,
                    );
                  },
                  menu: [
                    FSelectTile<Locale?>.suffix(
                      title: Text(l10n.settingsLanguageAuto),
                      value: null,
                    ),
                    FSelectTile<Locale?>.suffix(
                      title: Text(l10n.settingsLanguageEnglish),
                      value: const Locale('en'),
                    ),
                    FSelectTile<Locale?>.suffix(
                      title: Text(l10n.settingsLanguageFrench),
                      value: const Locale('fr'),
                    ),
                  ],
                ),
                FSelectMenuTile<Currency>(
                  selectControl: .managedRadio(
                    initial: settings.currency,
                    onChange: (values) {
                      if (values.isNotEmpty) settings.currency = values.first;
                    },
                  ),
                  prefix: Icon(settings.currency.icon),
                  title: Text(l10n.settingsCurrency),
                  detailsBuilder: (_, values, _) =>
                      Text(values.firstOrNull?.label ?? ''),
                  menu: [
                    for (final c in Currency.values)
                      FSelectTile<Currency>.suffix(
                        prefix: Icon(c.icon),
                        title: Text(c.label),
                        value: c,
                      ),
                  ],
                ),
              ],
            ),
            FTileGroup(
              label: Text(l10n.settingsBackup),
              children: [
                .tile(
                  enabled: !_isProcessing,
                  prefix: const Icon(FIcons.download),
                  title: Text(l10n.settingsBackup),
                  suffix: const Icon(FIcons.chevronRight),
                  onPress: _backup,
                ),
                .tile(
                  enabled: !_isProcessing,
                  prefix: const Icon(FIcons.upload),
                  title: Text(l10n.settingsRestore),
                  suffix: const Icon(FIcons.chevronRight),
                  onPress: _restore,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSquare extends StatelessWidget {
  static const _lightColor = Color(0xFFfafafa);
  static const _darkColor = Color(0xFF18181b);
  static const _size = 20.0;

  final ThemeMode mode;
  const _ThemeSquare({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        borderRadius: context.theme.style.borderRadius,
        border: Border.all(color: context.theme.colors.border),
      ),
      child: ClipRRect(
        borderRadius: context.theme.style.borderRadius,
        child: _buildFill(),
      ),
    );
  }

  Widget _buildFill() => switch (mode) {
    ThemeMode.light => const ColoredBox(color: _lightColor),
    ThemeMode.dark => const ColoredBox(color: _darkColor),
    ThemeMode.system => CustomPaint(painter: _DiagonalSplitPainter()),
  };
}

class _DiagonalSplitPainter extends CustomPainter {
  static const _lightColor = _ThemeSquare._lightColor;
  static const _darkColor = _ThemeSquare._darkColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = _lightColor;
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(0, size.height)
        ..close(),
      paint,
    );

    paint.color = _darkColor;
    canvas.drawPath(
      Path()
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DiagonalSplitPainter _) => false;
}
