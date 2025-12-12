import 'package:dartz/dartz.dart';
import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/repository/song/song_repository.dart';


class DeleteSongUseCase implements UseCase<Either<String, Unit>, String> {

  final SongsRepository _repository;
  DeleteSongUseCase(this._repository);

  @override
  Future<Either<String, Unit>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return Left('ID bài hát không hợp lệ');
    }
    return _repository.deleteSong(params);
  }
}