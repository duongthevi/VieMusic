import 'package:get_it/get_it.dart';

import '../data/repository/album/album_repository_impl.dart';
import '../data/sources/album/album_data_source.dart';
import '../data/sources/album/album_pocketbase_data_source.dart';
import '../domain/repository/album/album_repository.dart';
import '../domain/usecases/album/create_album.dart';
import '../domain/usecases/album/delete_album.dart';
import '../domain/usecases/album/get_album_details.dart';
import '../domain/usecases/album/get_all_albums.dart';
import '../domain/usecases/album/get_albums_by_artist.dart';
import '../domain/usecases/album/update_album.dart';
import '../presentation/album/bloc/album_details_cubit.dart';

void registerAlbumDependencies(GetIt sl) {
  sl.registerLazySingleton<AlbumDataSource>(
        () => AlbumPocketBaseDataSource(sl()),
  );

  sl.registerLazySingleton<AlbumRepository>(
        () => AlbumRepositoryImpl(sl(), sl()),
  );

  sl.registerFactory<GetAlbumDetailsUseCase>(
        () => GetAlbumDetailsUseCase(sl()),
  );

  sl.registerFactory<GetAlbumsByArtistUseCase>(
        () => GetAlbumsByArtistUseCase(sl()),
  );

  sl.registerFactory<GetAllAlbumsUseCase>(
        () => GetAllAlbumsUseCase(sl()),
  );

  sl.registerFactory<CreateAlbumUseCase>(
        () => CreateAlbumUseCase(sl()),
  );

  sl.registerFactory<UpdateAlbumUseCase>(
        () => UpdateAlbumUseCase(sl()),
  );

  sl.registerFactory<DeleteAlbumUseCase>(
        () => DeleteAlbumUseCase(sl()),
  );

  sl.registerFactory<AlbumDetailsCubit>(
        () => AlbumDetailsCubit(
      getAlbumDetailsUseCase: sl(),
      getAlbumSongsUseCase: sl(),
    ),
  );
}