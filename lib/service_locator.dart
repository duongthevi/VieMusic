import 'package:ct312h_project/injection/artist_dependencies.dart';
import 'package:ct312h_project/injection/playlist_dependencies.dart';
import 'package:ct312h_project/injection/profile_dependencies.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection/core_dependencies.dart';
import 'injection/auth_dependencies.dart';
import 'injection/search_dependencies.dart';
import 'injection/song_dependencies.dart';
import 'injection/album_dependencies.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  registerCoreDependencies(sl);
  registerAuthDependencies(sl);
  registerSongDependencies(sl);
  registerAlbumDependencies(sl);
  registerArtistDependencies(sl);
  registerSearchDependencies(sl);
  registerProfileDependencies(sl);
  registerPlaylistDependencies(sl);
}