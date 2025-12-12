import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:dartz/dartz.dart';

import '../../models/song/song_model.dart';
import '../../../domain/usecases/song/create_song_req.dart';
import '../../../domain/usecases/song/update_song_req.dart';

import '../base_data_source.dart';
import 'song_data_source.dart';

class SongPocketBaseDataSource extends BasePocketBaseDataSource
    implements SongDataSource {
  SongPocketBaseDataSource(super._client);

  List<String> _getLikedSongIds() {
    final user = pb.authStore.model;
    if (user == null) {
      return <String>[];
    }
    final likedTracks = user.data['liked_tracks'] as List<dynamic>?;
    return likedTracks?.map((id) => id.toString()).toList() ?? <String>[];
  }

  @override
  Future<Either<String, List<SongModel>>> getNewsSongs() async {
    return await tryCatchWrapper(() async {
      final likedSongIds = _getLikedSongIds();

      final result = await pb.collection(PbConstants.songsCollection).getList(
        perPage: 5,
        sort: '-release_date',
        expand: 'album,artists',
      );

      final songs = SongModel.mapRecordsToModels(
        records: result.items,
        likedSongIds: likedSongIds,
      );

      return songs;
    });
  }

  @override
  Future<Either<String, List<SongModel>>> getPlayList() async {
    return await tryCatchWrapper(() async {
      final likedSongIds = _getLikedSongIds();

      final result =
      await pb.collection(PbConstants.songsCollection).getFullList(
        sort: '-release_date',
        expand: 'album,artists',
      );


      final songs = SongModel.mapRecordsToModels(
        records: result,
        likedSongIds: likedSongIds,
      );

      return songs;
    });
  }

  @override
  Future<Either<String, SongModel>> getSongDetails(String songId) async {
    return await tryCatchWrapper(() async {
      final likedSongIds = _getLikedSongIds();

      final record = await pb.collection(PbConstants.songsCollection).getOne(
        songId,
        expand: 'album,artists',
      );

      final songModel = SongModel.fromJson(record.toJson());

      songModel.isFavorite = likedSongIds.contains(songModel.id);

      return songModel;
    });
  }

  @override
  Future<Either<String, SongModel>> createSong(CreateSongReq newSong) async {
    return await tryCatchWrapper(() async {
      final body = newSong.toPocketBaseBody();
      final file = await newSong.toPocketBaseFile();

      final record = await pb.collection(PbConstants.songsCollection).create(
        body: body,
        files: [file],
        expand: 'album,artists',
      );

      return SongModel.fromJson(record.toJson());
    });
  }

  @override
  Future<Either<String, SongModel>> updateSong(
      UpdateSongReq updatedSong) async {
    return await tryCatchWrapper(() async {
      final body = updatedSong.toPocketBaseBody();

      final record = await pb.collection(PbConstants.songsCollection).update(
        updatedSong.songId,
        body: body,
        expand: 'album,artists',
      );

      return SongModel.fromJson(record.toJson());
    });
  }

  @override
  Future<Either<String, Unit>> deleteSong(String songId) async {
    final result = await tryCatchWrapper(
          () => pb.collection(PbConstants.songsCollection).delete(songId),
    );
    return result.map((_) => unit);
  }

  @override
  Future<Either<String, bool>> addOrRemoveFavoriteSongs(String songId) async {
    if (!pb.authStore.isValid) {
      return const Left('User is not authenticated');
    }

    final String userId = pb.authStore.model.id;
    final List<String> currentLikedIds = _getLikedSongIds();
    final bool isNowFavorite;

    if (currentLikedIds.contains(songId)) {
      currentLikedIds.remove(songId);
      isNowFavorite = false;
    } else {
      currentLikedIds.add(songId);
      isNowFavorite = true;
    }

    final result = await tryCatchWrapper<void>(
          () => pb.collection(PbConstants.usersCollection).update(
        userId,
        body: {'liked_tracks': currentLikedIds},
      ),
    );

    if (result.isRight()) {
      pb.authStore.model.data['liked_tracks'] = currentLikedIds;
    }

    return result.map((_) => isNowFavorite);
  }

  @override
  Future<Either<String, bool>> isFavoriteSong(String songId) async {
    try {
      final likedSongIds = _getLikedSongIds();
      return Right(likedSongIds.contains(songId));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<SongModel>>> getUserFavoriteSongs() async {
    return await tryCatchWrapper(() async {
      final likedSongIds = _getLikedSongIds();

      if (likedSongIds.isEmpty) {
        return <SongModel>[];
      }

      final filter = likedSongIds.map((id) => "id='$id'").join(' || ');

      final result =
      await pb.collection(PbConstants.songsCollection).getFullList(
        filter: filter,
        expand: 'album,artists',
      );

      final songs = SongModel.mapRecordsToModels(
        records: result,
        likedSongIds: likedSongIds,
      );

      return songs;
    });
  }

  @override
  Future<Either<String, List<SongModel>>> getAlbumSongs(String albumId) async {
    return await tryCatchWrapper(() async {
      final likedSongIds = _getLikedSongIds();

      final result =
      await pb.collection(PbConstants.songsCollection).getFullList(
        filter: "album = '$albumId'",
        sort: '-release_date',
        expand: 'album,artists',
      );

      final songs = SongModel.mapRecordsToModels(
        records: result,
        likedSongIds: likedSongIds,
      );
      return songs;
    });
  }
}