import 'package:ct312h_project/data/models/album/album_model.dart';
import 'package:ct312h_project/domain/usecases/album/create_album_req.dart';
import 'package:ct312h_project/domain/usecases/album/update_album_req.dart';
import 'package:ct312h_project/domain/entities/album/album_entity.dart';
import 'package:ct312h_project/domain/repository/album/album_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/helpers/error_handler.dart';
import '../../sources/album/album_data_source.dart';
import '../../../core/database/pocketbase_client.dart';

class AlbumRepositoryImpl extends AlbumRepository {
  final AlbumDataSource albumDataSource;
  final PocketBaseClient client;

  AlbumRepositoryImpl(this.albumDataSource, this.client);

  @override
  Future<Either<String, AlbumEntity>> getAlbumDetails(String albumId) async {
    final result = await albumDataSource.getAlbumDetails(albumId);
    return result.fold(
            (error) => Left(ErrorHandler.mapError(error)),
            (model) => Right(model.toEntity(client: client)),
    );
  }

  @override
  Future<Either<String, List<AlbumEntity>>> getAlbumsByArtist(String artistId) async {
    final result = await albumDataSource.getAlbumsByArtist(artistId);
    return result.fold(
            (error) => Left(ErrorHandler.mapError(error)),
            (models) => Right(models.map((model) => model.toEntity(client: client)).toList()),
    );
  }

  @override
  Future<Either<String, List<AlbumEntity>>> getAllAlbums() async {
    final result = await albumDataSource.getAllAlbums();
    return result.map(
            (models) => models.map((model) => model.toEntity(client: client)).toList());
  }

  @override
  Future<Either<String, AlbumEntity>> createAlbum(CreateAlbumReq newAlbum) async {
    final result = await albumDataSource.createAlbum(newAlbum);

    return result.fold(
            (error) => Left(ErrorHandler.mapError(error)),
            (model) => Right(model.toEntity(client: client)),
    );
  }

  @override
  Future<Either<String, AlbumEntity>> updateAlbum(UpdateAlbumReq updatedAlbum) async {
    final result = await albumDataSource.updateAlbum(updatedAlbum);
    return result.fold(
            (error) => Left(ErrorHandler.mapError(error)),

            (model) => Right(model.toEntity(client: client)),
    );
  }

  @override
  Future<Either<String, Unit>> deleteAlbum(String albumId) async {
    final result = await albumDataSource.deleteAlbum(albumId);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }
}