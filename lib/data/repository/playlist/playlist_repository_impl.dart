import 'package:dartz/dartz.dart';
import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:ct312h_project/core/helpers/error_handler.dart';
import 'package:ct312h_project/domain/entities/playlist/playlist_entity.dart';
import 'package:ct312h_project/domain/repository/playlist/playlist_repository.dart';
import 'package:ct312h_project/domain/usecases/playlist/create_playlist_req.dart';
import 'package:ct312h_project/domain/usecases/playlist/remove_song_from_playlist_req.dart';
import 'package:ct312h_project/domain/usecases/playlist/update_playlist_req.dart';
import 'package:ct312h_project/data/sources/playlist/playlist_data_source.dart';

import '../../../domain/usecases/playlist/add_song_to_playlist_req.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistDataSource playlistDataSource;
  final PocketBaseClient client;

  PlaylistRepositoryImpl(this.playlistDataSource, this.client);

  List<String> _getLikedSongIds() {
    final user = client.pb.authStore.model;
    if (user == null) {
      return <String>[];
    }
    final likedTracks = user.data['liked_tracks'] as List<dynamic>?;
    return likedTracks?.map((id) => id.toString()).toList() ?? <String>[];
  }

  @override
  Future<Either<String, List<PlaylistEntity>>> getPlaylists() async {
    final result = await playlistDataSource.getPlaylists();
    final likedSongIds = _getLikedSongIds();

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (models) => Right(
        models
            .map((model) => model.toEntity(
          client: client,
          likedSongIds: likedSongIds,
        ))
            .toList(),
      ),
    );
  }

  @override
  Future<Either<String, PlaylistEntity>> getPlaylistById(
      String playlistId) async {
    final result = await playlistDataSource.getPlaylistById(playlistId);
    final likedSongIds = _getLikedSongIds();

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (model) => Right(
          model.toEntity(client: client, likedSongIds: likedSongIds)),
    );
  }

  @override
  Future<Either<String, PlaylistEntity>> createPlaylist(
      CreatePlaylistReq newPlaylist) async {
    final result = await playlistDataSource.createPlaylist(newPlaylist);
    final likedSongIds = _getLikedSongIds();

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (model) => Right(
          model.toEntity(client: client, likedSongIds: likedSongIds)),
    );
  }

  @override
  Future<Either<String, PlaylistEntity>> updatePlaylist(
      UpdatePlaylistReq newPlaylist) async {
    final result = await playlistDataSource.updatePlaylist(newPlaylist);
    final likedSongIds = _getLikedSongIds();

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (model) => Right(
          model.toEntity(client: client, likedSongIds: likedSongIds)),
    );
  }

  @override
  Future<Either<String, Unit>> deletePlaylist(String playlistId) async {
    final result = await playlistDataSource.deletePlaylist(playlistId);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<Either<String, Unit>> removeSongFromPlaylist(
      RemoveSongFromPlaylistReq params) async {
    final result = await playlistDataSource.removeSongFromPlaylist(params);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<Either<String, Unit>> addSongToPlaylist(
      AddSongToPlaylistReq req) async {
    final result = await playlistDataSource.addSongToPlaylist(req);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }
}