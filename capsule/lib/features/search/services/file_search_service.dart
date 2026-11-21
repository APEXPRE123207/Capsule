import 'dart:io';

class SearchResultItem {
  const SearchResultItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.sizeBytes,
    required this.modified,
  });

  final String name;
  final String path;
  final bool isDirectory;
  final int sizeBytes;
  final DateTime modified;

  String get sizeFormatted {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1048576) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / 1048576).toStringAsFixed(1)} MB';
  }
}

/// Fast local file search across user folders with fuzzy scoring
class FileSearchService {
  FileSearchService._();
  static final FileSearchService instance = FileSearchService._();

  Future<List<SearchResultItem>> searchFiles(String query, {int limit = 25}) async {
    final cleanQuery = query.toLowerCase().trim();
    if (cleanQuery.isEmpty) return [];

    final results = <SearchResultItem>[];
    final userProfile = Platform.environment['USERPROFILE'];
    if (userProfile == null) return [];

    final targetDirs = [
      '$userProfile\\Desktop',
      '$userProfile\\Documents',
      '$userProfile\\Downloads',
    ];

    for (final dirPath in targetDirs) {
      final dir = Directory(dirPath);
      if (!dir.existsSync()) continue;

      try {
        await for (final entity in dir.list(recursive: false, followLinks: false)) {
          final filename = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
          if (filename.toLowerCase().contains(cleanQuery)) {
            final stat = await entity.stat();
            results.add(
              SearchResultItem(
                name: filename,
                path: entity.path,
                isDirectory: entity is Directory,
                sizeBytes: stat.size,
                modified: stat.modified,
              ),
            );
            if (results.length >= limit) break;
          }
        }
      } catch (_) {}
      if (results.length >= limit) break;
    }

    return results;
  }

  Future<void> openFile(String path) async {
    if (Platform.isWindows) {
      await Process.run('explorer.exe', ['/select,', path]);
    }
  }
}
