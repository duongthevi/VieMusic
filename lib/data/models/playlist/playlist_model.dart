import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:ct312h_project/data/models/song/song_model.dart';
import 'package:ct312h_project/domain/entities/playlist/playlist_entity.dart';
import 'package:pocketbase/pocketbase.dart';

class PlaylistModel {
  final String id;
  final String name;
  final String description;
  final String cover;
  final bool isPublic;
  final String created;
  final String ownerId;
  final List<String> songIds;
  final List<SongModel>? songs;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.description,
    required this.cover,
    required this.isPublic,
    required this.created,
    required this.ownerId,
    required this.songIds,
    this.songs,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final expand = json['expand'] as Map<String, dynamic>? ?? {};

    final expandedSongs = (expand['songs'] as List<dynamic>?)
        ?.map((songJson) =>
        SongModel.fromJson(songJson as Map<String, dynamic>))
        .toList();

    return PlaylistModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      isPublic: json['is_public'] as bool? ?? false,
      created: json['created'] as String? ?? '',
      ownerId: json['owner'] as String? ?? '',
      songIds: (json['songs'] as List<dynamic>?)
          ?.map((id) => id.toString())
          .toList() ??
          [],
      songs: expandedSongs,
    );
  }

  PlaylistEntity toEntity({
    required PocketBaseClient client,
    required List<String> likedSongIds,
  }) {

    songs?.forEach((songModel) {
      songModel.isFavorite = likedSongIds.contains(songModel.id);
    });

    final songEntities = songs
        ?.map((songModel) => songModel.toEntity(
      client: client,
    ))
        .toList();

    return PlaylistEntity(
      id: id,
      name: name,
      description: description,
      isPublic: isPublic,
      created: DateTime.tryParse(created) ?? DateTime.now(),
      ownerId: ownerId,
      coverUrl: client.getFileUrl(
        collectionId: PbConstants.playlistsCollection,
        recordId: id,
        filename: cover,
      ),
      songs: songEntities ?? [],
    );
  }

  static List<PlaylistEntity> mapRecordsToEntities({
    required List<RecordModel> records,
    required PocketBaseClient client,
    required List<String> likedSongIds,
  }) {
    return records.map((record) {
      final playlistModel = PlaylistModel.fromJson(record.toJson());

      return playlistModel.toEntity(
        client: client,
        likedSongIds: likedSongIds,
      );
    }).toList();
  }
}