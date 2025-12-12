import 'package:ct312h_project/domain/repository/artist/artist_repository.dart';
import 'package:dartz/dartz.dart';

class UnfollowArtistUseCase {
  final ArtistRepository repository;

  UnfollowArtistUseCase(this.repository);

  Future<Either<String, Unit>> call(String artistId) {
    return repository.unfollowArtist(artistId);
  }
}