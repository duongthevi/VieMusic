import 'package:dartz/dartz.dart';
import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/usecases/song/update_song_req.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/domain/repository/song/song_repository.dart';


class UpdateSongUseCase implements UseCase<Either<String, SongEntity>, UpdateSongReq> {

  final SongsRepository _repository;
  UpdateSongUseCase(this._repository);

  @override
  Future<Either<String, SongEntity>> call({UpdateSongReq? params}) async {
    if (params == null) {
      return Left('Thông tin cập nhật không hợp lệ');
    }
    return _repository.updateSong(params);
  }
}