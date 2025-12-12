import 'package:ct312h_project/domain/repository/artist/artist_repository.dart';
import 'package:dartz/dartz.dart';

class IsArtistFollowedUseCase {
  final ArtistRepository repository;

  IsArtistFollowedUseCase(this.repository);

  Future<Either<String, bool>> call(String artistId) {
    return repository.isArtistFollowed(artistId);
  }
}