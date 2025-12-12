import 'package:ct312h_project/domain/entities/album/album_entity.dart';
import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';

class SongEntity {
  final String id;
  final String title;
  final String audioUrl;
  final num duration;
  final int playCount;
  final DateTime created;

  final AlbumEntity? album;
  final List<ArtistEntity>? artists;

  final bool isFavorite;

  SongEntity({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.duration,
    required this.playCount,
    required this.created,
    this.album,
    this.artists,
    required this.isFavorite,
  });
}