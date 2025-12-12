import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../repository/song/song_repository.dart';


class IsFavoriteSongUseCase implements UseCase<Either<String, bool>, String> {
  final SongsRepository _repository;
  IsFavoriteSongUseCase(this._repository);
  
  @override
  Future<Either<String, bool>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return Left('Song ID không hợp lệ');
    }
    return await _repository.isFavoriteSong(params);
  }
}