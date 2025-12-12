import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../repository/song/song_repository.dart';

class AddOrRemoveFavoriteSongUseCase implements UseCase<Either<String, bool>, String> {
  final SongsRepository _repository;
  AddOrRemoveFavoriteSongUseCase(this._repository);

  @override
  Future<Either<String, bool>> call({String? params}) async {

    if (params == null || params.isEmpty) {
      return Left('Song ID is invalid');
    }

    return await _repository.addOrRemoveFavoriteSongs(params);
  }
}