import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/playlist/playlist_entity.dart';
import '../../repository/playlist/playlist_repository.dart';
import 'create_playlist_req.dart';

class CreatePlaylistUseCase implements UseCase<Either<String, PlaylistEntity>, CreatePlaylistReq> {
  final PlaylistRepository _repository;
  CreatePlaylistUseCase(this._repository);

  @override
  Future<Either<String, PlaylistEntity>> call({CreatePlaylistReq? params}) async {
    if (params == null) {
      return Left('Invalid playlist information');
    }
    return _repository.createPlaylist(params);
  }
}