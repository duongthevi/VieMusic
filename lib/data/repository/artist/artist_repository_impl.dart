import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:ct312h_project/data/models/artist/artist_model.dart';
import 'package:ct312h_project/data/sources/artist/artist_data_source.dart';
import 'package:ct312h_project/data/sources/auth/auth_data_source.dart';
import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/domain/repository/artist/artist_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/helpers/error_handler.dart';

class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistDataSource dataSource;
  final AuthDataSource authDataSource;
  final PocketBaseClient client;

  ArtistRepositoryImpl(
      this.dataSource,
      this.authDataSource,
      this.client,
      );

  @override
  Future<Either<String, ArtistEntity>> getArtist(String artistId) async {
    final result = await dataSource.getArtist(artistId);

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (model) => Right(model.toEntity(client: client)),
    );
  }

  @override
  Future<Either<String, List<ArtistEntity>>> getAllArtists() async {
    final result = await dataSource.getAllArtists();

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (models) => Right(
        models.map((model) => model.toEntity(client: client)).toList(),
      ),
    );
  }

  @override
  Future<Either<String, List<SongEntity>>> getArtistSongs(String artistId) async {
    final result = await dataSource.getArtistSongs(artistId);

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (songModels) => Right(
        songModels.map((model) => model.toEntity(client: client)).toList(),
      ),
    );
  }

  @override
  Future<Either<String, List<ArtistEntity>>> getArtistsByIds(List<String> artistIds) async {
    final result = await dataSource.getArtistsByIds(artistIds);

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (models) => Right(
        models.map((model) => model.toEntity(client: client)).toList(),
      ),
    );
  }

  @override
  Future<Either<String, bool>> isArtistFollowed(String artistId) async {
    final result = await authDataSource.getFollowedArtistsIds();

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (followedArtists) => Right(followedArtists.contains(artistId)),
    );
  }

  @override
  Future<Either<String, Unit>> followArtist(String artistId) async {
    final result = await authDataSource.addFollowedArtist(artistId);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<Either<String, Unit>> unfollowArtist(String artistId) async {
    final result = await authDataSource.removeFollowedArtist(artistId);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }
}