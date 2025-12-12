import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/playlist/playlist_entity.dart';
import '../../repository/playlist/playlist_repository.dart';
import 'update_playlist_req.dart';

class UpdatePlaylistUseCase implements UseCase<Either<String, PlaylistEntity>, UpdatePlaylistReq> {
  final PlaylistRepository _repository;
  UpdatePlaylistUseCase(this._repository);

  @override
  Future<Either<String, PlaylistEntity>> call({UpdatePlaylistReq? params}) async {
    if (params == null) {
      return Left('Invalid update information');
    }
    // (Giả sử repository của bạn có hàm updatePlaylist)
    return _repository.updatePlaylist(params);
  }
}