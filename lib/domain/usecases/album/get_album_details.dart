import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/entities/album/album_entity.dart';
import 'package:ct312h_project/domain/repository/album/album_repository.dart';
import 'package:dartz/dartz.dart';

class GetAlbumDetailsUseCase implements UseCase<Either<String, AlbumEntity>, String> {

  final AlbumRepository _repository;
  GetAlbumDetailsUseCase(this._repository);

  @override
  Future<Either<String, AlbumEntity>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return Left('Album ID is invalid');
    }
    return _repository.getAlbumDetails(params);
  }
}