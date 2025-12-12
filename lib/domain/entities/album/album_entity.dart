import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';

class AlbumEntity {
  final String id;
  final String title;
  final String coverUrl;
  final DateTime releaseDate;
  final DateTime created;
  final List<ArtistEntity>? artists;

  AlbumEntity({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.releaseDate,
    required this.created,
    this.artists,
  });
}