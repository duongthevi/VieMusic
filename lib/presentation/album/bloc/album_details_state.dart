part of 'album_details_cubit.dart';

@immutable
abstract class AlbumDetailsState extends Equatable {
  const AlbumDetailsState();

  @override
  List<Object?> get props => [];
}

class AlbumDetailsInitial extends AlbumDetailsState {}

class AlbumDetailsLoading extends AlbumDetailsState {}

class AlbumDetailsFailure extends AlbumDetailsState {
  final String message;
  const AlbumDetailsFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class AlbumDetailsLoaded extends AlbumDetailsState {
  final AlbumEntity album;
  final List<SongEntity> songs;

  const AlbumDetailsLoaded({
    required this.album,
    required this.songs,
  });

  @override
  List<Object?> get props => [album, songs];
}