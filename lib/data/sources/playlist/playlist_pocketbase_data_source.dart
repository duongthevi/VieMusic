import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/usecases/playlist/add_song_to_playlist_req.dart';
import '../../../domain/usecases/playlist/remove_song_from_playlist_req.dart';
import '../../models/playlist/playlist_model.dart';
import '../../../domain/usecases/playlist/create_playlist_req.dart';
import '../../../domain/usecases/playlist/update_playlist_req.dart';
import '../base_data_source.dart';
import 'playlist_data_source.dart';

class PlaylistPocketBaseDataSource extends BasePocketBaseDataSource
    implements PlaylistDataSource {
  PlaylistPocketBaseDataSource(super._client);

  List<String> _getLikedSongIds() {
    final user = pb.authStore.model;
    if (user == null) {
      return <String>[];
    }
    final likedTracks = user.data['liked_tracks'] as List<dynamic>?;
    return likedTracks?.map((id) => id.toString()).toList() ?? <String>[];
  }

  @override
  Future<Either<String, List<PlaylistModel>>> getPlaylists() async {
    return await tryCatchWrapper(() async {
      final likedSongIds = _getLikedSongIds();

      final result =
      await pb.collection(PbConstants.playlistsCollection).getFullList(
        sort: '-created',
        expand: 'songs,songs.album,songs.artists,owner',
      );

      final playlists = result.map((record) {
        final model = PlaylistModel.fromJson(record.toJson());

        model.songs?.forEach((songModel) {
          songModel.isFavorite = likedSongIds.contains(songModel.id);
        });
        return model;
      }).toList();

      return playlists;
    });
  }

  @override
  Future<Either<String, PlaylistModel>> getPlaylistById(
      String playlistId) async {
    return await tryCatchWrapper(() async {
      final likedSongIds = _getLikedSongIds();

      final record =
      await pb.collection(PbConstants.playlistsCollection).getOne(
        playlistId,
        expand: 'songs,songs.album,songs.artists,owner',
      );

      final model = PlaylistModel.fromJson(record.toJson());

      model.songs?.forEach((songModel) {
        songModel.isFavorite = likedSongIds.contains(songModel.id);
      });

      return model;
    });
  }

  @override
  Future<Either<String, PlaylistModel>> createPlaylist(
      CreatePlaylistReq newPlaylist) async {
    return await tryCatchWrapper(() async {

      final body = newPlaylist.toPocketBaseBody();
      final coverFile = await newPlaylist.toPocketBaseCoverFile();

      final record =
      await pb.collection(PbConstants.playlistsCollection).create(
        body: body,
        files: coverFile != null ? [coverFile] : [],
        expand: 'songs,songs.album,songs.artists,owner',
      );

      final model = PlaylistModel.fromJson(record.toJson());
      final likedSongIds = _getLikedSongIds();
      model.songs?.forEach((songModel) {
        songModel.isFavorite = likedSongIds.contains(songModel.id);
      });

      return model;
    });
  }

  @override
  Future<Either<String, PlaylistModel>> updatePlaylist(
      UpdatePlaylistReq updatedPlaylist) async {
    return await tryCatchWrapper(() async {
      final body = updatedPlaylist.toPocketBaseBody();
      final coverFile = await updatedPlaylist.toPocketBaseCoverFile();

      final record =
      await pb.collection(PbConstants.playlistsCollection).update(
        updatedPlaylist.id,
        body: body,
        files: coverFile != null ? [coverFile] : [],
        expand: 'songs,songs.album,songs.artists,owner',
      );

      final model = PlaylistModel.fromJson(record.toJson());
      final likedSongIds = _getLikedSongIds();
      model.songs?.forEach((songModel) {
        songModel.isFavorite = likedSongIds.contains(songModel.id);
      });

      return model;
    });
  }

  @override
  Future<Either<String, Unit>> deletePlaylist(String playlistId) async {
    final result = await tryCatchWrapper(
          () => pb.collection(PbConstants.playlistsCollection).delete(playlistId),
    );
    return result.map((_) => unit);
  }

  @override
  Future<Either<String, Unit>> removeSongFromPlaylist(RemoveSongFromPlaylistReq params) async {
    final result = await tryCatchWrapper<void>(
          () => pb.collection(PbConstants.playlistsCollection).update(
        params.playlistId,
        body: {'songs-': [params.songId]},
      ),
    );
    return result.map((_) => unit);
  }

  @override
  Future<Either<String, Unit>> addSongToPlaylist(AddSongToPlaylistReq req) async {
    final result = await tryCatchWrapper<void>(
          () => pb.collection(PbConstants.playlistsCollection).update(
        req.playlistId,
        body: {'songs+': [req.songId]},
      ),
    );
    return result.map((_) => unit);
  }
}