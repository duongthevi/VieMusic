import 'package:get_it/get_it.dart';

import '../data/repository/playlist/playlist_repository_impl.dart';
import '../data/sources/playlist/playlist_data_source.dart';
import '../data/sources/playlist/playlist_pocketbase_data_source.dart';

import '../domain/repository/playlist/playlist_repository.dart';

import '../domain/usecases/playlist/add_song_to_playlist.dart';
import '../domain/usecases/playlist/create_playlist.dart';
import '../domain/usecases/playlist/delete_playlist.dart';
import '../domain/usecases/playlist/get_playlist_by_id.dart';
import '../domain/usecases/playlist/get_playlists.dart';
import '../domain/usecases/playlist/remove_song_from_playlist.dart';

import '../domain/usecases/playlist/update_playlist.dart';

import '../presentation/playlist/bloc/my_playlists_cubit.dart';
import '../presentation/playlist/bloc/playlist_details_cubit.dart';


void registerPlaylistDependencies(GetIt sl) {
  sl.registerLazySingleton<PlaylistDataSource>(
        () => PlaylistPocketBaseDataSource(sl()),
  );

  sl.registerLazySingleton<PlaylistRepository>(
        () => PlaylistRepositoryImpl(sl(), sl()),
  );

  sl.registerFactory<GetPlaylistsUseCase>(
        () => GetPlaylistsUseCase(sl()),
  );

  sl.registerFactory<GetPlaylistByIdUseCase>(
        () => GetPlaylistByIdUseCase(sl()),
  );

  sl.registerFactory<CreatePlaylistUseCase>(
        () => CreatePlaylistUseCase(sl()),
  );

  sl.registerFactory<DeletePlaylistUseCase>(
        () => DeletePlaylistUseCase(sl()),
  );

  sl.registerFactory<UpdatePlaylistUseCase>(
        () => UpdatePlaylistUseCase(sl()),
  );

  sl.registerFactory<RemoveSongFromPlaylistUseCase>(
        () => RemoveSongFromPlaylistUseCase(sl()),
  );

  sl.registerFactory<AddSongToPlaylistUseCase>(
        () => AddSongToPlaylistUseCase(sl()),
  );

  sl.registerFactory<MyPlaylistsCubit>(
        () => MyPlaylistsCubit(
      getPlaylistsUseCase: sl(),
      getUserUseCase: sl(),
      createPlaylistUseCase: sl(),
      addSongToPlaylistUseCase: sl(),
      updatePlaylistUseCase: sl(),
      deletePlaylistUseCase: sl(),
    ),
  );

  sl.registerFactory<PlaylistDetailsCubit>(
        () => PlaylistDetailsCubit(
      getPlaylistByIdUseCase: sl(),
      removeSongFromPlaylistUseCase: sl(),
    ),
  );
}