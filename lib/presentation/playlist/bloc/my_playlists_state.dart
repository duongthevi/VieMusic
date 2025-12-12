part of 'my_playlists_cubit.dart';

@immutable
abstract class MyPlaylistsState extends Equatable {
  const MyPlaylistsState();

  @override
  List<Object?> get props => [];
}

class MyPlaylistsInitial extends MyPlaylistsState {}

class MyPlaylistsLoading extends MyPlaylistsState {}

class MyPlaylistsFailure extends MyPlaylistsState {
  final String message;
  const MyPlaylistsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class MyPlaylistsLoaded extends MyPlaylistsState {
  final List<PlaylistEntity> myPlaylists;
  final List<PlaylistEntity> publicPlaylists;
  final DateTime loadedAt;

  MyPlaylistsLoaded({
    required this.myPlaylists,
    required this.publicPlaylists,
  }) : loadedAt = DateTime.now();

  @override
  List<Object?> get props => [myPlaylists, publicPlaylists, loadedAt];
}