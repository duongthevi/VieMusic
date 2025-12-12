import 'package:get_it/get_it.dart';

import '../data/repository/artist/artist_repository_impl.dart';
import '../data/sources/artist/artist_data_source.dart';
import '../data/sources/artist/artist_pocketbase_data_source.dart';
import '../domain/repository/artist/artist_repository.dart';
import '../domain/usecases/artist/get_all_artists.dart';
import '../domain/usecases/artist/get_artist.dart';
import '../domain/usecases/artist/get_artist_details_by_ids.dart';
import '../domain/usecases/artist/get_artist_songs.dart';
import '../domain/usecases/artist/is_artist_followed.dart';
import '../domain/usecases/artist/follow_artist.dart';
import '../domain/usecases/artist/unfollow_artist.dart';

import 'package:ct312h_project/presentation/artist/bloc/artist_details_cubit.dart';

import '../presentation/profile/bloc/followed_artists_cubit.dart';

void registerArtistDependencies(GetIt sl) {
  sl.registerLazySingleton<ArtistDataSource>(
        () => ArtistPocketBaseDataSource(sl()),
  );

  sl.registerLazySingleton<ArtistRepository>(
        () => ArtistRepositoryImpl(sl(), sl(), sl()),
  );

  sl.registerFactory<GetAllArtistsUseCase>(
        () => GetAllArtistsUseCase(sl()),
  );

  sl.registerFactory<GetArtistUseCase>(
        () => GetArtistUseCase(sl()),
  );

  sl.registerFactory<GetArtistSongsUseCase>(
        () => GetArtistSongsUseCase(sl()),
  );

  sl.registerFactory<GetArtistDetailsByIdsUseCase>(
        () => GetArtistDetailsByIdsUseCase(sl()),
  );

  // THÊM: Đăng ký các Use Case theo dõi
  sl.registerFactory<IsArtistFollowedUseCase>(
        () => IsArtistFollowedUseCase(sl()),
  );

  sl.registerFactory<FollowArtistUseCase>(
        () => FollowArtistUseCase(sl()),
  );

  sl.registerFactory<UnfollowArtistUseCase>(
        () => UnfollowArtistUseCase(sl()),
  );

  sl.registerFactory<ArtistDetailsCubit>(
        () => ArtistDetailsCubit(
      getArtistUseCase: sl(),
      getArtistSongsUseCase: sl(),
      isArtistFollowedUseCase: sl(),
      followArtistUseCase: sl(),
      unfollowArtistUseCase: sl(),
    ),
  );

  sl.registerFactory<FollowedArtistsCubit>(
        () => FollowedArtistsCubit(
      getArtistDetailsByIdsUseCase: sl(),
    ),
  );
}