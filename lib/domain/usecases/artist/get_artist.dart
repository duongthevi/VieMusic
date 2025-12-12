import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';
import 'package:ct312h_project/domain/repository/artist/artist_repository.dart';
import 'package:dartz/dartz.dart';

class GetArtistUseCase {
  final ArtistRepository repository;

  GetArtistUseCase(this.repository);

  Future<Either<String, ArtistEntity>> call(String artistId) {
    return repository.getArtist(artistId);
  }
}