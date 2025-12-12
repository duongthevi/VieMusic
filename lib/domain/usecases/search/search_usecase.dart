import 'package:dartz/dartz.dart';
import 'package:ct312h_project/core/usecase/usecase.dart';
import 'package:ct312h_project/domain/entities/search/search_entity.dart';
import 'package:ct312h_project/domain/repository/search/search_repository.dart';


class SearchUseCase implements UseCase<Either<String, SearchResultEntity>, String> {
  final SearchRepository repository;

  SearchUseCase({required this.repository});

  @override
  Future<Either<String, SearchResultEntity>> call({String? params}) async {
    if (params == null || params.trim().isEmpty) {
      return Right(SearchResultEntity.empty());
    }

    return await repository.search(params);
  }
}