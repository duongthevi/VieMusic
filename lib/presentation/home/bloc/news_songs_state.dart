import 'package:equatable/equatable.dart';
import '../../../domain/entities/song/song_entity.dart';

abstract class NewsSongsState extends Equatable {
  const NewsSongsState();

  @override
  List<Object> get props => [];
}

class NewsSongsInitial extends NewsSongsState {}

class NewsSongsLoading extends NewsSongsState {}

class NewsSongsLoaded extends NewsSongsState {
  final List<SongEntity> songs;
  const NewsSongsLoaded({required this.songs});

  @override
  List<Object> get props => [songs];
}

class NewsSongsFailure extends NewsSongsState {
  final String message;
  const NewsSongsFailure({required this.message});

  @override
  List<Object> get props => [message];
}