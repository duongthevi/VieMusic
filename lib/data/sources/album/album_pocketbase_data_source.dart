import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:ct312h_project/data/models/album/album_model.dart';
import 'package:ct312h_project/domain/usecases/album/create_album_req.dart';
import 'package:ct312h_project/domain/usecases/album/update_album_req.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../models/song/song_model.dart';
import '../base_data_source.dart';
import 'album_data_source.dart';

class AlbumPocketBaseDataSource extends BasePocketBaseDataSource implements AlbumDataSource {

  AlbumPocketBaseDataSource(super._client);

  List<String> _getLikedSongIds() {
    final user = pb.authStore.model;
    if (user == null) {
      return <String>[];
    }
    final likedTracks = user.data['liked_tracks'] as List<dynamic>?;
    return likedTracks?.map((id) => id.toString()).toList() ?? <String>[];
  }

  @override
  Future<Either<String, AlbumModel>> getAlbumDetails(String albumId) async {
    return await tryCatchWrapper(() async {
      final record = await pb.collection(PbConstants.albumsCollection).getOne(
        albumId,
        expand: 'artists',
      );
      return AlbumModel.fromJson(record.toJson());
    });
  }

  @override
  Future<Either<String, List<AlbumModel>>> getAlbumsByArtist(String artistId) async {
    return await tryCatchWrapper(() async {
      final result = await pb.collection(PbConstants.albumsCollection).getFullList(
        filter: "artists.id ?= '$artistId'",
        expand: 'artists',
        sort: '-release_date',
      );

      final albums = result.map((record) {
        return AlbumModel.fromJson(record.toJson());
      }).toList();

      return albums;
    });
  }

  @override
  Future<Either<String, List<AlbumModel>>> getAllAlbums() async {
    return await tryCatchWrapper(() async {
      final result = await pb.collection(PbConstants.albumsCollection).getFullList(
        expand: 'artists',
        sort: '-release_date',
      );

      final albums = result.map((record) {
        return AlbumModel.fromJson(record.toJson());
      }).toList();

      return albums;
    });
  }

  @override
  Future<Either<String, AlbumModel>> createAlbum(CreateAlbumReq newAlbum) async {
    return await tryCatchWrapper(() async {
      final body = newAlbum.toPocketBaseBody();
      final file = await newAlbum.toPocketBaseFile();

      final record = await pb.collection(PbConstants.albumsCollection).create(
        body: body,
        files: [file],
        expand: 'artists',
      );

      return AlbumModel.fromJson(record.toJson());
    });
  }

  @override
  Future<Either<String, AlbumModel>> updateAlbum(UpdateAlbumReq updatedAlbum) async {
    return await tryCatchWrapper(() async {
      final body = updatedAlbum.toPocketBaseBody();
      final file = await updatedAlbum.toPocketBaseFile();

      final List<http.MultipartFile> files = [];
      if (file != null) {
        files.add(file);
      }

      final record = await pb.collection(PbConstants.albumsCollection).update(
        updatedAlbum.albumId,
        body: body,
        files: files,
        expand: 'artists',
      );

      return AlbumModel.fromJson(record.toJson());
    });
  }

  @override
  Future<Either<String, Unit>> deleteAlbum(String albumId) async {
    final result = await tryCatchWrapper(
          () => pb.collection(PbConstants.albumsCollection).delete(albumId),
    );

    return result.map((_) => unit);
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