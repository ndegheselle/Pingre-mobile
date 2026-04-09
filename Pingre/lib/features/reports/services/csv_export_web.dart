import 'dart:html' as html;

/// Triggers a browser download of the CSV file. Returns null (no local path).
Future<String?> saveCsvFile(List<int> bytes, String filename) async {
  final blob = html.Blob([bytes], 'text/csv');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
  return null;
}
