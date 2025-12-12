import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../entities/playlist/playlist_entity.dart';
import '../../repository/playlist/playlist_repository.dart';

class GetPlaylistByIdUseCase implements UseCase<Either<String, PlaylistEntity>, String> {
  final PlaylistRepository _repository;
  GetPlaylistByIdUseCase(this._repository);

  @override
  Future<Either<String, PlaylistEntity>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return Left('Playlist ID is required');
    }
    return _repository.getPlaylistById(params);
  }
}