import 'package:equatable/equatable.dart';
import 'package:ct312h_project/domain/entities/search/search_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchFailure extends SearchState {
  final String message;

  const SearchFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class SearchEmpty extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchResultEntity searchResult;

  const SearchLoaded({required this.searchResult});

  @override
  List<Object> get props => [searchResult];
}