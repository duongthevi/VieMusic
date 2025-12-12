import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:ct312h_project/data/models/artist/artist_model.dart';
import 'package:ct312h_project/domain/entities/album/album_entity.dart';

class AlbumModel {
  final String id;
  final String title;
  final String cover;
  final String releaseDate;
  final String created;

  final List<String> artistIds;
  final List<ArtistModel>? artists;

  AlbumModel({
    required this.id,
    required this.title,
    required this.cover,
    required this.releaseDate,
    required this.created,
    required this.artistIds,
    this.artists,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    final expand = json['expand'] as Map<String, dynamic>? ?? {};

    final expandedArtists = (expand['artists'] as List<dynamic>?)
        ?.map((artistJson) =>
        ArtistModel.fromJson(artistJson as Map<String, dynamic>))
        .toList();

    return AlbumModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      releaseDate: json['release_date'] as String? ?? '',
      created: json['created'] as String? ?? '',
      artistIds: (json['artists'] as List<dynamic>?)
          ?.map((id) => id.toString())
          .toList() ??
          [],
      artists: expandedArtists,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'cover': cover,
      'release_date': releaseDate,
      'artists': artistIds,
    };
  }
}

extension AlbumModelX on AlbumModel {
  AlbumEntity toEntity({required PocketBaseClient client}) {
    return AlbumEntity(
      id: id,
      title: title,
      releaseDate: DateTime.tryParse(releaseDate) ?? DateTime(1970),
      created: DateTime.tryParse(created) ?? DateTime.now(),

      coverUrl: client.getFileUrl(
        collectionId: PbConstants.albumsCollection,
        recordId: id,
        filename: cover,
      ),

      artists: artists
          ?.map((artistModel) => artistModel.toEntity(client: client))
          .toList(),
    );
  }
}