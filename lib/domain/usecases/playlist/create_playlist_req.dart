import 'dart:io';
import 'package:http/http.dart' as http;

class CreatePlaylistReq {
  final String name;
  final String description;
  final bool isPublic;
  final String ownerId;
  final List<String> songIds;
  final File? cover;

  CreatePlaylistReq({
    required this.name,
    required this.ownerId,
    this.description = '',
    this.isPublic = false,
    this.songIds = const [],
    this.cover,
  });

  Map<String, dynamic> toPocketBaseBody() {
    return {
      'name': name,
      'description': description,
      'is_public': isPublic,
      'owner': ownerId,
      'songs': songIds,
    };
  }

  Future<http.MultipartFile?> toPocketBaseCoverFile() async {
    if (cover == null) {
      return null;
    }
    return await http.MultipartFile.fromPath(
      'cover',
      cover!.path,
    );
  }
}