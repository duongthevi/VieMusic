import 'package:equatable/equatable.dart';
import '../../../domain/entities/song/song_entity.dart';

abstract class FavoriteSongsState extends Equatable {
  const FavoriteSongsState();
  @override
  List<Object> get props => [];
}

class FavoriteSongsInitial extends FavoriteSongsState {}

class FavoriteSongsLoading extends FavoriteSongsState {}

class FavoriteSongsLoaded extends FavoriteSongsState {
  final List<SongEntity> favoriteSongs;
  const FavoriteSongsLoaded({required this.favoriteSongs});
  @override
  List<Object> get props => [favoriteSongs];
}

class FavoriteSongsFailure extends FavoriteSongsState {
  final String message;
  const FavoriteSongsFailure({required this.message});

  @override
  List<Object> get props => [message];
}