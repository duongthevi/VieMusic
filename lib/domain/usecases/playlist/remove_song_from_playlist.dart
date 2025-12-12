import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../repository/playlist/playlist_repository.dart';
import 'remove_song_from_playlist_req.dart';

class RemoveSongFromPlaylistUseCase implements UseCase<Either<String, Unit>, RemoveSongFromPlaylistReq> {
  final PlaylistRepository _repository;
  RemoveSongFromPlaylistUseCase(this._repository);

  @override
  Future<Either<String, Unit>> call({RemoveSongFromPlaylistReq? params}) async {
    if (params == null) {
      return Left('Playlist ID and Song ID are required');
    }
    return _repository.removeSongFromPlaylist(params);
  }
}