import 'package:dartz/dartz.dart';
import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/usecases/song/create_song_req.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/domain/repository/song/song_repository.dart';


class CreateSongUseCase implements UseCase<Either<String, SongEntity>, CreateSongReq> {

  final SongsRepository _repository;
  CreateSongUseCase(this._repository);

  @override
  Future<Either<String, SongEntity>> call({CreateSongReq? params}) async {
    if (params == null) {
      return Left('Thông tin bài hát không hợp lệ');
    }
    return _repository.createSong(params);
  }
}