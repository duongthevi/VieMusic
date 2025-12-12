import 'package:ct312h_project/data/models/song/song_model.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/usecases/song/create_song_req.dart';
import '../../../domain/usecases/song/update_song_req.dart';

abstract class SongDataSource {
  Future<Either<String, List<SongModel>>> getNewsSongs();
  Future<Either<String, List<SongModel>>> getPlayList();
  Future<Either<String, SongModel>> createSong(CreateSongReq newSong);
  Future<Either<String, SongModel>> updateSong(UpdateSongReq updatedSong);
  Future<Either<String, Unit>> deleteSong(String songId);

  Future<Either<String, bool>> addOrRemoveFavoriteSongs(String songId);
  Future<Either<String, bool>> isFavoriteSong(String songId);
  Future<Either<String, List<SongModel>>> getUserFavoriteSongs();
  Future<Either<String, SongModel>> getSongDetails(String songId);
  Future<Either<String, List<SongModel>>> getAlbumSongs(String albumId);
}