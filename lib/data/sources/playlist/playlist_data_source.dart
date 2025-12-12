import 'package:ct312h_project/data/models/playlist/playlist_model.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/usecases/playlist/add_song_to_playlist_req.dart';
import '../../../domain/usecases/playlist/create_playlist_req.dart';
import '../../../domain/usecases/playlist/remove_song_from_playlist_req.dart';
import '../../../domain/usecases/playlist/update_playlist_req.dart';

abstract class PlaylistDataSource {
  Future<Either<String, List<PlaylistModel>>> getPlaylists();
  Future<Either<String, PlaylistModel>> getPlaylistById(String playlistId);
  Future<Either<String, PlaylistModel>> createPlaylist(CreatePlaylistReq newPlaylist);
  Future<Either<String, PlaylistModel>> updatePlaylist(UpdatePlaylistReq newPlaylist);
  Future<Either<String, Unit>> deletePlaylist(String playlistId);
  Future<Either<String, Unit>> removeSongFromPlaylist(RemoveSongFromPlaylistReq playlist);
  Future<Either<String, Unit>> addSongToPlaylist(AddSongToPlaylistReq req);
}