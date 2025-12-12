import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../service_locator.dart';
import '../../playlist/bloc/my_playlists_cubit.dart';

class MyPlaylistsWidget extends StatelessWidget {
  const MyPlaylistsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyPlaylistsCubit>()..loadPlaylists(),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<MyPlaylistsCubit, MyPlaylistsState>(
      builder: (context, state) {
        if (state is MyPlaylistsLoading || state is MyPlaylistsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MyPlaylistsFailure) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is MyPlaylistsLoaded) {
          if (state.myPlaylists.isEmpty && state.publicPlaylists.isEmpty) {
            return const Center(
              child: Text(
                'No playlists found.\nPress + to create a new one.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'My Playlists'),
                _buildPlaylistList(context, state.myPlaylists),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Public Playlists'),
                _buildPlaylistList(context, state.publicPlaylists),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlaylistList(BuildContext context, List<PlaylistEntity> playlists) {
    if (playlists.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
        child: Text(
          'No playlists in this section.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlists.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        final coverUrl = playlist.coverUrl;
        final bool hasCover = coverUrl.isNotEmpty;

        return InkWell(
          onTap: () {
            context.push('/playlist-details/${playlist.id}');
          },
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade700,
                    image: hasCover
                        ? DecorationImage(
                      image: NetworkImage(coverUrl),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: hasCover
                      ? null
                      : const Icon(Icons.queue_music_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        playlist.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${playlist.songs.length} songs',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        );
      },
    );
  }
}