import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/song/get_news_songs.dart';
import '../../../service_locator.dart';
import 'news_songs_state.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {
  NewsSongsCubit() : super(NewsSongsInitial());

  Future<void> getNewsSongs() async {
    emit(NewsSongsLoading());

    var returnedSongs = await sl<GetNewsSongsUseCase>().call();

    returnedSongs.fold(
          (failureMessage) {
        emit(NewsSongsFailure(message: failureMessage));
      },
          (data) {
        emit(
          NewsSongsLoaded(songs: data),
        );
      },
    );
  }
}