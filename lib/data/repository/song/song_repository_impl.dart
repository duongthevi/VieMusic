import 'package:ct312h_project/core/helpers/error_handler.dart';
import 'package:ct312h_project/domain/usecases/song/create_song_req.dart';
import 'package:ct312h_project/domain/usecases/song/update_song_req.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/repository/song/song_repository.dart';
import '../../sources/song/song_data_source.dart';

import 'package:ct312h_project/core/database/pocketbase_client.dart';

class SongRepositoryImpl extends SongsRepository {
  final SongDataSource songDataSource;
  final PocketBaseClient client;

  SongRepositoryImpl(this.songDataSource, this.client);

  @override
  Future<Either<String, List<SongEntity>>> getNewsSongs() async {
    final result = await songDataSource.getNewsSongs();
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (models) => Right(
        models.map((model) => model.toEntity(client: client)).toList(),
      ),
    );
  }

  @override
  Future<Either<String, List<SongEntity>>> getPlayList() async {
    final result = await songDataSource.getPlayList();
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (models) => Right(
        models.map((model) => model.toEntity(client: client)).toList(),
      ),
    );
  }

  @override
  Future<Either<String, SongEntity>> createSong(CreateSongReq newSong) async {
    final result = await songDataSource.createSong(newSong);

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (model) => Right(model.toEntity(client: client)),
    );
  }

  @override
  Future<Either<String, SongEntity>> updateSong(
      UpdateSongReq updatedSong) async {
    final result = await songDataSource.updateSong(updatedSong);

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (model) => Right(model.toEntity(client: client)),
    );
  }

  @override
  Future<Either<String, Unit>> deleteSong(String songId) async {
    final result = await songDataSource.deleteSong(songId);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<Either<String, bool>> addOrRemoveFavoriteSongs(String songId) async {
    final result = await songDataSource.addOrRemoveFavoriteSongs(songId);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<Either<String, bool>> isFavoriteSong(String songId) async {
    final result = await songDataSource.isFavoriteSong(songId);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (isFavorite) => Right(isFavorite),
    );
  }

  @override
  Future<Either<String, List<SongEntity>>> getUserFavoriteSongs() async {
    final result = await songDataSource.getUserFavoriteSongs();
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (models) => Right(
        models.map((model) => model.toEntity(client: client)).toList(),
      ),
    );
  }

  @override
  Future<Either<String, SongEntity>> getSongDetails(String songId) async {
    final result = await songDataSource.getSongDetails(songId);

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (model) => Right(model.toEntity(client: client)),
    );
  }

  @override
  Future<Either<String, List<SongEntity>>> getAlbumSongs(
      String? albumId) async {
    if (albumId == null || albumId.isEmpty) {
      return const Left('Album ID is required');
    }

    final result = await songDataSource.getAlbumSongs(albumId);

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (models) => Right(
        models.map((model) => model.toEntity(client: client)).toList(),
      ),
    );
  }
}