import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';

abstract class ArtistsListState {}

class ArtistsListLoading extends ArtistsListState {}

class ArtistsListLoaded extends ArtistsListState {
  final List<ArtistEntity> artists;
  ArtistsListLoaded({required this.artists});
}

class ArtistsListFailure extends ArtistsListState {
  final String message;
  ArtistsListFailure({required this.message});
}