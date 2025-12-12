import 'package:ct312h_project/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ct312h_project/presentation/playlist/bloc/my_playlists_cubit.dart';
import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../service_locator.dart';

class PlaylistsPreview extends StatelessWidget {
  const PlaylistsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyPlaylistsCubit>(
      create: (_) => sl<MyPlaylistsCubit>()..loadPlaylists(),
      child: SizedBox(
        height: 120,
        child: BlocBuilder<MyPlaylistsCubit, MyPlaylistsState>(
          builder: (context, state) {
            if (state is MyPlaylistsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is MyPlaylistsFailure) {
              return Center(
                child: Text(
                  'Failed to load playlists: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (state is MyPlaylistsLoaded) {
              final List<PlaylistEntity> playlistsToShow =
              state.myPlaylists.take(5).toList();

              if (playlistsToShow.isEmpty) {
                return Center(
                  child: Text(
                    "You haven't created any playlists yet.",
                    style: TextStyle(
                        color: context.isDarkMode ? Colors.white70 : Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return _buildPlaylists(context, playlistsToShow);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPlaylists(BuildContext context, List<PlaylistEntity> playlists) {
    final isDark = context.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;

    const double coverSize = 75.0;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: playlists.length,
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        final coverUrl = playlist.coverUrl;
        final bool hasCover = coverUrl != null && coverUrl.isNotEmpty;

        final Color placeholderColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade300;
        final Color iconColor = Colors.white;

        return InkWell(
          onTap: () {
            context.push('/playlist-details/${playlist.id}');
          },
          child: SizedBox(
            width: coverSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: coverSize,
                  height: coverSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: placeholderColor,
                    image: hasCover
                        ? DecorationImage(
                      image: NetworkImage(coverUrl),
                      fit: BoxFit.cover,
                    )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: hasCover
                      ? null
                      : Icon(Icons.queue_music_rounded,
                      color: iconColor, size: 35),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    playlist.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}