import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';
import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:pocketbase/pocketbase.dart';

class ArtistModel {
  final String id;
  final String name;
  final String cover;
  final String bio;
  final String created;

  ArtistModel({
    required this.id,
    required this.name,
    required this.cover,
    required this.bio,
    required this.created,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      created: json['created'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cover': cover,
      'bio': bio,
    };
  }

  static List<ArtistModel> mapRecordsToModels({
    required List<RecordModel> records,
  }) {
    //
    return records
        .map((record) => ArtistModel.fromJson(record.toJson()))
        .toList();
  }
}

extension ArtistModelX on ArtistModel {
  ArtistEntity toEntity({required PocketBaseClient client}) {
    return ArtistEntity(
      id: id,
      name: name,
      bio: bio,
      created: DateTime.tryParse(created) ?? DateTime.now(),
      coverUrl: client.getFileUrl(
        collectionId: PbConstants.artistsCollection,
        recordId: id,
        filename: cover,
      ),
    );
  }
}