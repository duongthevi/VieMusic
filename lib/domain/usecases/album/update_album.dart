import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/usecases/album/update_album_req.dart';
import 'package:ct312h_project/domain/entities/album/album_entity.dart';
import 'package:ct312h_project/domain/repository/album/album_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateAlbumUseCase implements UseCase<Either<String, AlbumEntity>, UpdateAlbumReq> {

  final AlbumRepository _repository;
  UpdateAlbumUseCase(this._repository);

  @override
  Future<Either<String, AlbumEntity>> call({UpdateAlbumReq? params}) async {
    if (params == null) {
      return Left('Invalid update information');
    }
    return _repository.updateAlbum(params);
  }
}