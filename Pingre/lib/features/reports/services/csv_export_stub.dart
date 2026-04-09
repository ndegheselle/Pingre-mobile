/// Stub for platforms that don't support file I/O or HTML download.
Future<String?> saveCsvFile(List<int> bytes, String filename) async {
  return null;
}
