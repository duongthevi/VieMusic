import 'package:ct312h_project/domain/entities/playlist/playlist_entity.dart';
import 'package:ct312h_project/domain/usecases/playlist/create_playlist_req.dart';
import 'package:ct312h_project/domain/usecases/playlist/update_playlist_req.dart';
import 'package:dartz/dartz.dart';
import '../../usecases/playlist/add_song_to_playlist_req.dart';
import '../../usecases/playlist/remove_song_from_playlist_req.dart';

abstract class PlaylistRepository {
  Future<Either<String, List<PlaylistEntity>>> getPlaylists();

  Future<Either<String, PlaylistEntity>> getPlaylistById(String playlistId);

  Future<Either<String, PlaylistEntity>> createPlaylist(CreatePlaylistReq newPlaylist);

  Future<Either<String, PlaylistEntity>> updatePlaylist(UpdatePlaylistReq newPlaylist);

  Future<Either<String, Unit>> deletePlaylist(String playlistId);

  Future<Either<String, Unit>> removeSongFromPlaylist(RemoveSongFromPlaylistReq playlist);

  Future<Either<String, Unit>> addSongToPlaylist(AddSongToPlaylistReq req);
}