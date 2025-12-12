import 'package:dartz/dartz.dart';
import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/domain/repository/song/song_repository.dart';

class GetAlbumSongsUseCase implements UseCase<Either<String, List<SongEntity>>, String> {
  final SongsRepository repository;

  GetAlbumSongsUseCase(this.repository);

  @override
  Future<Either<String, List<SongEntity>>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return const Left('Album ID is required');
    }

    return await repository.getAlbumSongs(params);
  }
}