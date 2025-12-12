import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/artist/artist_entity.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../domain/usecases/artist/get_artist.dart';
import '../../../domain/usecases/artist/get_artist_songs.dart';
import '../../../domain/usecases/artist/is_artist_followed.dart';
import '../../../domain/usecases/artist/follow_artist.dart';
import '../../../domain/usecases/artist/unfollow_artist.dart';

part 'artist_details_state.dart';

class ArtistDetailsCubit extends Cubit<ArtistDetailsState> {
  final GetArtistUseCase getArtistUseCase;
  final GetArtistSongsUseCase getArtistSongsUseCase;
  final IsArtistFollowedUseCase isArtistFollowedUseCase;
  final FollowArtistUseCase followArtistUseCase;
  final UnfollowArtistUseCase unfollowArtistUseCase;

  ArtistDetailsCubit({
    required this.getArtistUseCase,
    required this.getArtistSongsUseCase,
    required this.isArtistFollowedUseCase,
    required this.followArtistUseCase,
    required this.unfollowArtistUseCase,
  }) : super(ArtistDetailsInitial());

  Future<void> loadArtistDetails(String artistId) async {
    emit(ArtistDetailsLoading());

    try {
      final artistResult = await getArtistUseCase(artistId);

      await artistResult.fold(
            (failureMessage) {
          emit(ArtistDetailsFailure(message: failureMessage));
        },
            (artistEntity) async {
          final isFollowedResult = await isArtistFollowedUseCase(artistId);
          final isFollowed = isFollowedResult.fold(
                (_) => false,
                (isFollowed) => isFollowed,
          );

          final songsResult = await getArtistSongsUseCase(artistId);

          await songsResult.fold(
                (failureMessage) {
              emit(ArtistDetailsFailure(message: failureMessage));
            },
                (songsList) {
              emit(ArtistDetailsLoaded(
                artist: artistEntity,
                songs: songsList,
                isFollowed: isFollowed,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(ArtistDetailsFailure(message: e.toString()));
    }
  }

  Future<void> toggleFollowArtist(String artistId) async {
    if (state is ArtistDetailsLoaded) {
      final currentState = state as ArtistDetailsLoaded;
      final currentIsFollowed = currentState.isFollowed;

      emit(currentState.copyWith(isFollowed: !currentIsFollowed));

      final result = currentIsFollowed
          ? await unfollowArtistUseCase(artistId)
          : await followArtistUseCase(artistId);

      result.fold(
            (failureMessage) {
          emit(currentState.copyWith(isFollowed: currentIsFollowed));
          print('Lỗi theo dõi: $failureMessage');
        },
            (_) {
        },
      );
    }
  }
}