import 'package:dartz/dartz.dart';

import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/domain/repository/song/song_repository.dart';


class GetSongDetailsUseCase implements UseCase<Either<String, SongEntity>, String> {
  final SongsRepository repository;

  GetSongDetailsUseCase({required this.repository});

  @override
  Future<Either<String, SongEntity>> call({String? params}) async {
    if (params == null || params.isEmpty) {
      return const Left('Song ID is required');
    }

    return await repository.getSongDetails(params);
  }
}