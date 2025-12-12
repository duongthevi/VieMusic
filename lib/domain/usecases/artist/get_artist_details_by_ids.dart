import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';
import 'package:ct312h_project/domain/repository/artist/artist_repository.dart';
import 'package:dartz/dartz.dart';

class GetArtistDetailsByIdsUseCase {
  final ArtistRepository repository;

  GetArtistDetailsByIdsUseCase(this.repository);

  Future<Either<String, List<ArtistEntity>>> call(List<String> artistIds) {
    return repository.getArtistsByIds(artistIds);
  }
}
