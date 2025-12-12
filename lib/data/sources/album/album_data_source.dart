import 'package:ct312h_project/data/models/album/album_model.dart';
import 'package:ct312h_project/domain/usecases/album/create_album_req.dart';
import 'package:ct312h_project/domain/usecases/album/update_album_req.dart';
import 'package:dartz/dartz.dart';

import '../../models/song/song_model.dart';

abstract class AlbumDataSource {
  Future<Either<String, AlbumModel>> getAlbumDetails(String albumId);
  Future<Either<String, List<AlbumModel>>> getAlbumsByArtist(String artistId);
  Future<Either<String, List<AlbumModel>>> getAllAlbums();
  Future<Either<String, AlbumModel>> createAlbum(CreateAlbumReq newAlbum);
  Future<Either<String, AlbumModel>> updateAlbum(UpdateAlbumReq updatedAlbum);
  Future<Either<String, Unit>> deleteAlbum(String albumId);
  Future<Either<String, List<SongModel>>> getAlbumSongs(String albumId);
}