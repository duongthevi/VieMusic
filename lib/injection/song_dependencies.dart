import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import '../data/repository/song/song_repository_impl.dart';
import '../data/sources/song/song_data_source.dart';
import '../data/sources/song/song_pocketbase_data_source.dart';
import '../domain/repository/song/song_repository.dart';
import '../domain/usecases/song/add_or_remove_favorite_song.dart';
import '../domain/usecases/song/create_song.dart';
import '../domain/usecases/song/delete_song.dart';
import '../domain/usecases/song/get_album_songs.dart';
import '../domain/usecases/song/get_favorite_songs.dart';
import '../domain/usecases/song/get_news_songs.dart';
import '../domain/usecases/song/get_play_list.dart';
import '../domain/usecases/song/is_favorite_song.dart';
import '../domain/usecases/song/update_song.dart';
import '../domain/usecases/song/get_song_details.dart';
import '../presentation/song_player/bloc/song_player_cubit.dart';


void registerSongDependencies(GetIt sl) {
  sl.registerLazySingleton<SongDataSource>(
        () => SongPocketBaseDataSource(sl()),
  );

  sl.registerLazySingleton<SongsRepository>(
        () => SongRepositoryImpl(sl(), sl()),
  );

  sl.registerFactory<GetNewsSongsUseCase>(
        () => GetNewsSongsUseCase(sl()),
  );

  sl.registerFactory<GetPlayListUseCase>(
        () => GetPlayListUseCase(sl()),
  );

  sl.registerFactory<GetSongDetailsUseCase>(
        () => GetSongDetailsUseCase(repository: sl()),
  );

  sl.registerFactory<CreateSongUseCase>(
        () => CreateSongUseCase(sl()),
  );

  sl.registerFactory<UpdateSongUseCase>(
        () => UpdateSongUseCase(sl()),
  );

  sl.registerFactory<DeleteSongUseCase>(
        () => DeleteSongUseCase(sl()),
  );

  sl.registerFactory<AddOrRemoveFavoriteSongUseCase>(
        () => AddOrRemoveFavoriteSongUseCase(sl()),
  );

  sl.registerFactory<IsFavoriteSongUseCase>(
        () => IsFavoriteSongUseCase(sl()),
  );

  sl.registerFactory<GetFavoriteSongsUseCase>(
        () => GetFavoriteSongsUseCase(sl()),
  );

  sl.registerLazySingleton<AudioPlayer>(
        () => AudioPlayer(),
  );

  sl.registerFactory<SongPlayerCubit>(
        () => SongPlayerCubit(
      audioPlayer: sl(),
      getSongDetailsUseCase: sl(),
    ),
  );

  sl.registerFactory<GetAlbumSongsUseCase>(
        () => GetAlbumSongsUseCase(sl()),
  );
}