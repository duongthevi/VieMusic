import 'package:equatable/equatable.dart';

import '../../../../domain/entities/song/song_entity.dart';
import '../../../../domain/entities/artist/artist_entity.dart';

class SearchResultEntity extends Equatable {
  final List<SongEntity> songs;
  final List<ArtistEntity> artists;
  // Bạn có thể thêm: final List<AlbumEntity> albums;

  const SearchResultEntity({
    required this.songs,
    required this.artists,
    // required this.albums,
  });

  factory SearchResultEntity.empty() {
    return const SearchResultEntity(
      songs: [],
      artists: [],
      // albums: [],
    );
  }

  bool get isEmpty => songs.isEmpty && artists.isEmpty /* && albums.isEmpty */;

  @override
  List<Object?> get props => [songs, artists /*, albums */];
}