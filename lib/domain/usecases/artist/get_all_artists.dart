import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';
import 'package:ct312h_project/domain/repository/artist/artist_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllArtistsUseCase {
  final ArtistRepository repository;

  GetAllArtistsUseCase(this.repository);

  Future<Either<String, List<ArtistEntity>>> call() {
    return repository.getAllArtists();
  }
}