import 'package:equatable/equatable.dart';
import '../../../domain/entities/song/song_entity.dart';

abstract class PlayListState extends Equatable {
  const PlayListState();

  @override
  List<Object> get props => [];
}

class PlayListInitial extends PlayListState {}

class PlayListLoading extends PlayListState {}

class PlayListLoaded extends PlayListState {
  final List<SongEntity> songs;
  const PlayListLoaded({required this.songs});

  @override
  List<Object> get props => [songs];
}

class PlayListFailure extends PlayListState {
  final String message;
  const PlayListFailure({required this.message});

  @override
  List<Object> get props => [message];
}