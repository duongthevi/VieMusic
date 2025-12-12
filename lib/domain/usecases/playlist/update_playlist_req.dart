import 'dart:io';
import 'package:http/http.dart' as http;

class UpdatePlaylistReq {
  final String id;
  final String? name;
  final String? description;
  final bool? isPublic;
  final File? cover;

  UpdatePlaylistReq({
    required this.id,
    this.name,
    this.description,
    this.isPublic,
    this.cover,
  });


  Map<String, dynamic> toPocketBaseBody() {
    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (isPublic != null) body['is_public'] = isPublic;
    return body;
  }

  Future<http.MultipartFile?> toPocketBaseCoverFile() async {
    if (cover == null) {
      return null;
    }
    return await http.MultipartFile.fromPath('cover', cover!.path);
  }
}