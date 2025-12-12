import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';
import 'package:ct312h_project/domain/usecases/artist/get_artist_details_by_ids.dart';

import 'followed_artists_state.dart';

class FollowedArtistsCubit extends Cubit<FollowedArtistsState> {
  final GetArtistDetailsByIdsUseCase getArtistDetailsByIdsUseCase;

  FollowedArtistsCubit({
    required this.getArtistDetailsByIdsUseCase,
  }) : super(FollowedArtistsInitial());

  Future<void> loadFollowedArtists(List<String> artistIds) async {
    if (artistIds.isEmpty) {
      return emit(FollowedArtistsLoaded(artists: const []));
    }

    emit(FollowedArtistsLoading());

    try {
      final result = await getArtistDetailsByIdsUseCase(artistIds);

      result.fold(
            (failureMessage) {
          emit(FollowedArtistsFailure(message: failureMessage));
        },
            (artistsList) {
          emit(FollowedArtistsLoaded(artists: artistsList));
        },
      );
    } catch (e) {
      emit(FollowedArtistsFailure(message: e.toString()));
    }
  }
}