import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/song/song_entity.dart';
import '../../../domain/usecases/song/get_favorite_songs.dart';
import '../../../service_locator.dart';
import 'favorite_songs_state.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  FavoriteSongsCubit() : super(FavoriteSongsInitial());

  Future<void> getFavoriteSongs() async {
    emit(FavoriteSongsLoading());
    var result  = await sl<GetFavoriteSongsUseCase>().call();
    result.fold(
            (failureMessage){
          emit(
              FavoriteSongsFailure(message: failureMessage)
          );
        },
            (songsList){
          emit(
              FavoriteSongsLoaded(favoriteSongs: songsList)
          );
        }
    );
  }

  void removeSong(int index) {
    if (state is FavoriteSongsLoaded) {
      final currentSongs = (state as FavoriteSongsLoaded).favoriteSongs;
      final updatedSongs = List<SongEntity>.from(currentSongs);
      updatedSongs.removeAt(index);
      emit(
          FavoriteSongsLoaded(favoriteSongs: updatedSongs)
      );
    }
  }
}