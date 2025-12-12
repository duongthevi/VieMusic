import 'package:equatable/equatable.dart';
import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';

abstract class FollowedArtistsState extends Equatable {
  const FollowedArtistsState();

  @override
  List<Object?> get props => [];
}

class FollowedArtistsInitial extends FollowedArtistsState {}

class FollowedArtistsLoading extends FollowedArtistsState {}

class FollowedArtistsFailure extends FollowedArtistsState {
  final String message;
  const FollowedArtistsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class FollowedArtistsLoaded extends FollowedArtistsState {
  final List<ArtistEntity> artists;
  // Thêm timestamp để đảm bảo state luôn được coi là mới
  final DateTime loadedAt;

  FollowedArtistsLoaded({required this.artists})
      : loadedAt = DateTime.now();

  @override
  List<Object> get props => [artists, loadedAt];
}