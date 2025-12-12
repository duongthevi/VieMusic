import 'package:ct312h_project/data/models/album/album_model.dart';
import 'package:ct312h_project/data/models/artist/artist_model.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';

import 'package:pocketbase/pocketbase.dart';

class SongModel {
  final String id;
  final String title;
  final String audio;
  final num duration;
  final int playCount;
  final String created;

  final String albumId;
  final AlbumModel? album;

  final List<String> artistIds;
  final List<ArtistModel>? artists;

  bool isFavorite;

  SongModel({
    required this.id,
    required this.title,
    required this.audio,
    required this.duration,
    required this.playCount,
    required this.created,
    required this.albumId,
    this.album,
    required this.artistIds,
    this.artists,
    this.isFavorite = false,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    final expand = json['expand'] as Map<String, dynamic>? ?? {};

    final expandedAlbumJson = expand['album'] as Map<String, dynamic>?;
    final expandedAlbum = expandedAlbumJson != null
        ? AlbumModel.fromJson(expandedAlbumJson)
        : null;

    final expandedArtists = (expand['artists'] as List<dynamic>? ?? [])
        .map((artistJson) =>
        ArtistModel.fromJson(artistJson as Map<String, dynamic>))
        .toList();

    return SongModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      audio: json['audio'] as String? ?? '',
      duration: (json['duration_seconds'] as num?) ?? 0,
      playCount: (json['play_count'] as num?)?.toInt() ?? 0,
      created: json['created'] as String? ?? '',
      albumId: json['album'] as String? ?? '',
      artistIds: (json['artists'] as List<dynamic>?)
          ?.map((id) => id.toString())
          .toList() ??
          [],
      album: expandedAlbum,
      artists: expandedArtists,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'audio': audio,
      'duration': duration,
      'album': albumId,
      'artists': artistIds,
    };
  }

  SongEntity toEntity({
    required PocketBaseClient client,
  }) {
    return SongEntity(
      id: id,
      title: title,
      duration: duration,
      playCount: playCount,
      created: DateTime.tryParse(created) ?? DateTime.now(),
      isFavorite: isFavorite,
      audioUrl: client.getFileUrl(
        collectionId: PbConstants.songsCollection,
        recordId: id,
        filename: audio,
      ),
      album: album?.toEntity(client: client),
      artists: artists
          ?.map((artistModel) => artistModel.toEntity(client: client))
          .toList(),
    );
  }

  static List<SongModel> mapRecordsToModels({
    required List<RecordModel> records,
    required List<String> likedSongIds,
  }) {
    return records.map((record) {
      final songModel = SongModel.fromJson(record.toJson());
      songModel.isFavorite = likedSongIds.contains(songModel.id);
      return songModel;
    }).toList();
  }
}