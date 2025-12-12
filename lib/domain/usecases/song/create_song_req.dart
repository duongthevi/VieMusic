import 'package:http/http.dart' as http;

class CreateSongReq {
  final String title;
  final num duration;
  final String albumId;
  final List<String> artistIds;
  final String audioFilePath;

  CreateSongReq({
    required this.title,
    required this.duration,
    required this.albumId,
    required this.artistIds,
    required this.audioFilePath,
  });

  Map<String, dynamic> toPocketBaseBody() {
    return {
      'title': title,
      'duration': duration,
      'album': albumId,
      'artists': artistIds,
      'play_count': 0,
    };
  }

  Future<http.MultipartFile> toPocketBaseFile() async {
    return await http.MultipartFile.fromPath(
      'audio',
      audioFilePath,
    );
  }
}