import 'package:ct312h_project/domain/usecases/album/create_album_req.dart';
import 'package:ct312h_project/domain/usecases/album/update_album_req.dart';
import 'package:ct312h_project/domain/entities/album/album_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AlbumRepository {
  Future<Either<String, AlbumEntity>> getAlbumDetails(String albumId);
  Future<Either<String, List<AlbumEntity>>> getAlbumsByArtist(String artistId);
  Future<Either<String, List<AlbumEntity>>> getAllAlbums();
  Future<Either<String, AlbumEntity>> createAlbum(CreateAlbumReq newAlbum);
  Future<Either<String, AlbumEntity>> updateAlbum(UpdateAlbumReq updatedAlbum);
  Future<Either<String, Unit>> deleteAlbum(String albumId);
}