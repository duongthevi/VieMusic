import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/playlist/playlist_entity.dart';
import '../../repository/playlist/playlist_repository.dart';

class GetPlaylistsUseCase implements UseCase<Either<String, List<PlaylistEntity>>, void> {
  final PlaylistRepository _repository;
  GetPlaylistsUseCase(this._repository);

  @override
  Future<Either<String, List<PlaylistEntity>>> call({void params}) async {
    return _repository.getPlaylists();
  }
}