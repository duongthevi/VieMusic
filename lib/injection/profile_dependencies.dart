import 'package:get_it/get_it.dart';

import 'package:ct312h_project/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:ct312h_project/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:ct312h_project/presentation/profile/bloc/edit_profile_cubit.dart';

void registerProfileDependencies(GetIt sl) {
  sl.registerFactory<ProfileInfoCubit>(
          () => ProfileInfoCubit());

  sl.registerFactory<FavoriteSongsCubit>(
          () => FavoriteSongsCubit());


  sl.registerFactory<EditProfileCubit>(
          () => EditProfileCubit(
        sl(),
        sl(),
      ));
}