import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import '../../../common/helpers/is_dark_mode.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/database/pocketbase_client.dart';
import '../../../service_locator.dart';

import '../bloc/profile_info_cubit.dart';
import '../widgets/favorite_songs.dart';
import '../widgets/followed_artists.dart';
import '../widgets/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDarkMode;

    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;

    return BlocProvider(
      create: (context) => sl<ProfileInfoCubit>()..getUser(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: BasicAppbar(
          backgroundColor: isDark ? const Color(0xff2C2B2B) : Colors.white,
          title: Text(
            'Profile',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(),

              const SizedBox(height: 30),

              _buildSectionWrapper(
                context,
                title: 'Followed Artists',
                cardBackgroundColor: cardColor,
                textColor: textColor,
                child: const FollowedArtistsSection(),
              ),

              const SizedBox(height: 30),

              _buildSectionWrapper(
                context,
                title: 'Favorite Songs',
                cardBackgroundColor: cardColor,
                textColor: textColor,
                child: const FavoriteSongsSection(),
              ),

              const SizedBox(height: 60),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    sl<PocketBaseClient>().logout();
                    if (context.mounted) {
                      context.go('/signup-or-signin');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.redAccent.withOpacity(0.5),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionWrapper(
      BuildContext context, {
        required String title,
        required Widget child,
        required Color cardBackgroundColor,
        required Color textColor,
      }) {
    final isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}