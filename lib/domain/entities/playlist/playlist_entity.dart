import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:equatable/equatable.dart';

class PlaylistEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String coverUrl;
  final bool isPublic;
  final DateTime created;
  final String ownerId;
  final List<SongEntity> songs;

  const PlaylistEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.coverUrl,
    required this.isPublic,
    required this.created,
    required this.ownerId,
    required this.songs,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    coverUrl,
    isPublic,
    created,
    ownerId,
    songs,
  ];
}