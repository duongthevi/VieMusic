import 'package:ct312h_project/data/models/artist/artist_model.dart';
import 'package:dartz/dartz.dart';
import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:ct312h_project/core/helpers/error_handler.dart';
import 'package:ct312h_project/data/sources/search/search_data_source.dart';
import 'package:ct312h_project/domain/entities/search/search_entity.dart';
import 'package:ct312h_project/domain/repository/search/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDataSource searchDataSource;
  final PocketBaseClient client;

  SearchRepositoryImpl({
    required this.searchDataSource,
    required this.client,
  });

  @override
  Future<Either<String, SearchResultEntity>> search(String query) async {
    final result = await searchDataSource.search(query);

    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (modelsTuple) {
        final (songModels, artistModels) = modelsTuple;

        final songEntities = songModels
            .map((model) => model.toEntity(client: client))
            .toList();

        final artistEntities = artistModels
            .map((model) => model.toEntity(client: client))
            .toList();

        return Right(
          SearchResultEntity(
            songs: songEntities,
            artists: artistEntities,
          ),
        );
      },
    );
  }
}