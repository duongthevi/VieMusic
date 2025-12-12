import 'package:dartz/dartz.dart';
import 'package:ct312h_project/domain/entities/search/search_entity.dart';

abstract class SearchRepository {
  Future<Either<String, SearchResultEntity>> search(String query);
}