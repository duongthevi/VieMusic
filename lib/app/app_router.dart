import 'package:ct312h_project/presentation/artist/pages/artist_details_page.dart';
import 'package:ct312h_project/presentation/choose_mode/pages/choose_mode.dart';
import 'package:ct312h_project/presentation/home/pages/home.dart';
import 'package:go_router/go_router.dart';

import 'package:ct312h_project/presentation/intro/pages/get_started.dart';

import 'package:ct312h_project/presentation/auth/pages/signin.dart';
import 'package:ct312h_project/presentation/auth/pages/signup.dart';

import 'package:ct312h_project/presentation/profile/pages/profile.dart';
import 'package:ct312h_project/presentation/song_player/pages/song_player.dart';
import 'package:ct312h_project/presentation/search/pages/search.dart';

import '../core/database/pocketbase_client.dart';
import '../presentation/album/pages/album_details_page.dart';

import 'package:ct312h_project/presentation/playlist/pages/my_playlists_page.dart';
import 'package:ct312h_project/presentation/playlist/pages/playlist_details_page.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:ct312h_project/domain/entities/auth/user_entity.dart'; // <--- Import đã có

import '../presentation/auth/pages/reset_password.dart';
import '../presentation/profile/pages/change_password.dart';
import '../presentation/profile/pages/edit_profile.dart';
import '../presentation/auth/pages/signup_or_signin.dart';
import '../service_locator.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: sl<PocketBaseClient>().isAuthenticated ? '/' : '/get-started',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/get-started',
        name: 'getStarted',
        builder: (context, state) => const GetStartedPage(),
      ),
      GoRoute(
        path: '/choose-mode',
        name: 'chooseMode',
        builder: (context, state) => const ChooseModePage(),
      ),
      GoRoute(
        path: '/signup-or-signin',
        name: 'signupOrSignin',
        builder: (context, state) => const SignupOrSigninPage(),
      ),
      GoRoute(
        path: '/signin',
        name: 'signin',
        builder: (context, state) => SigninPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/change-password',
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) => ResetPasswordPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      GoRoute(
        path: '/song-player',
        name: 'songPlayer',
        builder: (context, state) {
          final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;

          final List<SongEntity> queue = (extra?['queue'] as List<SongEntity>?) ?? [];
          final int initialIndex = (extra?['initialIndex'] as int?) ?? 0;

          final String songId = queue.isNotEmpty
              ? queue[initialIndex].id
              : 'default_id';

          return SongPlayerPage(
            songId: songId,
            queue: queue,
            initialIndex: initialIndex,
          );
        },
      ),

      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),

      GoRoute(
        path: '/artist/:id',
        name: 'artist',
        builder: (context, state) {
          final artistId = state.pathParameters['id']!;
          return ArtistDetailsPage(artistId: artistId);
        },
      ),

      GoRoute(
        path: '/album/:id',
        name: 'albumDetails',
        builder: (context, state) {
          final albumId = state.pathParameters['id']!;
          return AlbumDetailsPage(albumId: albumId);
        },
      ),

      GoRoute(
        path: '/my-playlists',
        name: 'myPlaylists',
        builder: (context, state) {
          return const MyPlaylistsPage();
        },
      ),

      GoRoute(
        path: '/playlist-details/:id',
        name: 'playlistDetails',
        builder: (context, state) {
          final playlistId = state.pathParameters['id']!;
          return PlaylistDetailsPage(playlistId: playlistId);
        },
      ),

      GoRoute(
        path: '/edit-profile',
        name: 'editProfile',
        builder: (context, state) {
          final userEntity = state.extra as UserEntity;
          return EditProfilePage(userEntity: userEntity);
        },
      ),
    ],
  );
}