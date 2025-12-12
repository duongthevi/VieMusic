import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/domain/usecases/song/update_song_req.dart';
import 'package:dartz/dartz.dart';

import '../../usecases/song/create_song_req.dart';

abstract class SongsRepository {
  Future<Either<String, List<SongEntity>>> getNewsSongs();

  Future<Either<String, List<SongEntity>>> getPlayList();

  Future<Either<String, SongEntity>> createSong(CreateSongReq newSong);

  Future<Either<String, SongEntity>> updateSong(UpdateSongReq updatedSong);

  Future<Either<String, Unit>> deleteSong(String songId);

  Future<Either<String, bool>> addOrRemoveFavoriteSongs(String songId);

  Future<Either<String, bool>> isFavoriteSong(String songId);

  Future<Either<String, List<SongEntity>>> getUserFavoriteSongs();

  Future<Either<String, SongEntity>> getSongDetails(String songId);

  Future<Either<String, List<SongEntity>>> getAlbumSongs(String? albumId);
}