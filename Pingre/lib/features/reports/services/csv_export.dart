import 'dart:typed_data';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

/// Shows a native save dialog and writes the CSV. Returns the saved path, or
/// null if the user cancelled.
Future<String?> saveCsvFile(Uint8List bytes, String filename) async {
  final params = SaveFileDialogParams(
    fileName: filename,
    data: bytes,
    mimeTypesFilter: ['text/csv'],
  );
  return FlutterFileDialog.saveFile(params: params);
}
