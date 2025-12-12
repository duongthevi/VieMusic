import 'package:http/http.dart' as http;

class CreateAlbumReq {
  final String title;
  final DateTime releaseDate;
  final List<String> artistIds;
  final String coverFilePath;

  CreateAlbumReq({
    required this.title,
    required this.releaseDate,
    required this.artistIds,
    required this.coverFilePath,
  });

  Map<String, dynamic> toPocketBaseBody() {
    return {
      'title': title,
      'artists': artistIds,
      'release_date': releaseDate.toIso8601String(),
    };
  }

  Future<http.MultipartFile> toPocketBaseFile() async {
    return await http.MultipartFile.fromPath(
      'cover',
      coverFilePath,
    );
  }
}