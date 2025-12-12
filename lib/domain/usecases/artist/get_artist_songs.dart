import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/domain/repository/artist/artist_repository.dart';
import 'package:dartz/dartz.dart';

class GetArtistSongsUseCase {
  final ArtistRepository repository;

  GetArtistSongsUseCase(this.repository);

  Future<Either<String, List<SongEntity>>> call(String artistId) {
    return repository.getArtistSongs(artistId);
  }
}