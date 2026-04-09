import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Saves the CSV file to the app's documents directory. Returns the full path.
Future<String?> saveCsvFile(List<int> bytes, String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = '${dir.path}/$filename';
  await File(path).writeAsBytes(bytes);
  return path;
}
