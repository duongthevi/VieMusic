part of 'artist_details_cubit.dart';

@immutable
abstract class ArtistDetailsState extends Equatable {
  const ArtistDetailsState();

  @override
  List<Object?> get props => [];
}

class ArtistDetailsInitial extends ArtistDetailsState {}

class ArtistDetailsLoading extends ArtistDetailsState {}

class ArtistDetailsFailure extends ArtistDetailsState {
  final String message;
  const ArtistDetailsFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class ArtistDetailsLoaded extends ArtistDetailsState {
  final ArtistEntity artist;
  final List<SongEntity> songs;
  final bool isFollowed;

  const ArtistDetailsLoaded({
    required this.artist,
    required this.songs,
    required this.isFollowed,
  });

  ArtistDetailsLoaded copyWith({
    ArtistEntity? artist,
    List<SongEntity>? songs,
    bool? isFollowed,
  }) {
    return ArtistDetailsLoaded(
      artist: artist ?? this.artist,
      songs: songs ?? this.songs,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }

  @override
  List<Object?> get props => [artist, songs, isFollowed];
}