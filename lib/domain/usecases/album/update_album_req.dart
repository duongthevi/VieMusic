import 'package:http/http.dart' as http;

class UpdateAlbumReq {
  final String albumId;
  final String? title;
  final DateTime? releaseDate;
  final List<String>? artistIds;
  final String? coverFilePath;

  UpdateAlbumReq({
    required this.albumId,
    this.title,
    this.releaseDate,
    this.artistIds,
    this.coverFilePath,
  });

  Map<String, dynamic> toPocketBaseBody() {
    final body = <String, dynamic>{};

    if (title != null) {
      body['title'] = title;
    }
    if (releaseDate != null) {
      body['release_date'] = releaseDate!.toIso8601String();
    }
    if (artistIds != null) {
      body['artists'] = artistIds;
    }

    return body;
  }

  Future<http.MultipartFile?> toPocketBaseFile() async {
    if (coverFilePath == null || coverFilePath!.isEmpty) {
      return null;
    }
    return await http.MultipartFile.fromPath(
      'cover',
      coverFilePath!,
    );
  }
}