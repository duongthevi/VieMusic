import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/usecases/album/create_album_req.dart';
import 'package:ct312h_project/domain/entities/album/album_entity.dart';
import 'package:ct312h_project/domain/repository/album/album_repository.dart';
import 'package:dartz/dartz.dart';


class CreateAlbumUseCase implements UseCase<Either<String, AlbumEntity>, CreateAlbumReq> {

  final AlbumRepository _repository;
  CreateAlbumUseCase(this._repository);

  @override
  Future<Either<String, AlbumEntity>> call({CreateAlbumReq? params}) async {
    if (params == null) {
      return Left('Invalid album information');
    }
    return _repository.createAlbum(params);
  }
}