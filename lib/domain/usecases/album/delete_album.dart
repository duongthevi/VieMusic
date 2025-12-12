import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/repository/album/album_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAlbumUseCase implements UseCase<Either<String, Unit>, String> {
  final AlbumRepository _repository;
  DeleteAlbumUseCase(this._repository);

  @override
  Future<Either<String, Unit>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return Left('Album ID is invalid');
    }
    return _repository.deleteAlbum(params);
  }
}