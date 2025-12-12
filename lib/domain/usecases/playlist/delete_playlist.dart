import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../repository/playlist/playlist_repository.dart';

class DeletePlaylistUseCase implements UseCase<Either<String, Unit>, String> {
  final PlaylistRepository _repository;
  DeletePlaylistUseCase(this._repository);

  @override
  Future<Either<String, Unit>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return Left('Playlist ID is required');
    }
    return _repository.deletePlaylist(params);
  }
}