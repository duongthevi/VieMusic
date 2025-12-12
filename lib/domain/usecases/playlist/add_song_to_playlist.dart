import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../repository/playlist/playlist_repository.dart';
import 'add_song_to_playlist_req.dart';

class AddSongToPlaylistUseCase implements UseCase<Either<String, Unit>, AddSongToPlaylistReq> {
  final PlaylistRepository _repository;

  AddSongToPlaylistUseCase(this._repository);

  @override
  Future<Either<String, Unit>> call({AddSongToPlaylistReq? params}) async {
    if (params == null) {
      return const Left('Invalid song or playlist information');
    }
    return _repository.addSongToPlaylist(params);
  }
}