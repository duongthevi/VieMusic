import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/entities/album/album_entity.dart';
import 'package:ct312h_project/domain/repository/album/album_repository.dart';
import 'package:dartz/dartz.dart';

class GetAlbumsByArtistUseCase implements UseCase<Either<String, List<AlbumEntity>>, String> {

  final AlbumRepository _repository;
  GetAlbumsByArtistUseCase(this._repository);

  @override
  Future<Either<String, List<AlbumEntity>>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return Left('Artist ID is invalid');
    }
    return _repository.getAlbumsByArtist(params);
  }
}