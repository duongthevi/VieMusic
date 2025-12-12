import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/entities/album/album_entity.dart';
import 'package:ct312h_project/domain/repository/album/album_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllAlbumsUseCase implements UseCase<Either<String, List<AlbumEntity>>, void> {

  final AlbumRepository _repository;
  GetAllAlbumsUseCase(this._repository);

  @override
  Future<Either<String, List<AlbumEntity>>> call({void params}) async {
    return _repository.getAllAlbums();
  }
}