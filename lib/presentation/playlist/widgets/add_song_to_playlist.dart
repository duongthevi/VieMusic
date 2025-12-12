import 'package:ct312h_project/common/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../service_locator.dart';
import '../bloc/my_playlists_cubit.dart';

class AddSongToPlaylistDialog extends StatelessWidget {
  final SongEntity song;
  const AddSongToPlaylistDialog({
    required this.song,
    super.key,
  });

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red : AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyPlaylistsCubit>(
      create: (_) => sl<MyPlaylistsCubit>()..loadMyPlaylistsOnly(),
      child: Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              BasicAppbar(
                title: Text(
                  'Add "${song.title}" to Playlist',
                  style: const TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onLeadingPressed: () => context.pop(),
              ),
              Expanded(
                child: BlocConsumer<MyPlaylistsCubit, MyPlaylistsState>(
                  listener: (context, state) {
                    if (state is MyPlaylistsFailure) {
                      _showSnackBar(context, state.message, isError: true);
                    }
                  },
                  builder: (context, state) {
                    if (state is MyPlaylistsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is MyPlaylistsFailure) {
                      return Center(
                        child: Text('Error: ${state.message}'),
                      );
                    }

                    if (state is MyPlaylistsLoaded) {
                      final myPlaylists = state.myPlaylists;

                      if (myPlaylists.isEmpty) {
                        return const Center(
                          child: Text("You don't have any playlists."),
                        );
                      }

                      return ListView.builder(
                        itemCount: myPlaylists.length,
                        itemBuilder: (context, index) {
                          final playlist = myPlaylists[index];
                          final isSongInPlaylist = playlist.songs.any((s) => s.id == song.id);

                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: BorderRadius.circular(8),
                                image: (playlist.coverUrl.isNotEmpty)
                                    ? DecorationImage(
                                  image: NetworkImage(playlist.coverUrl),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: (playlist.coverUrl.isEmpty)
                                  ? const Icon(Icons.queue_music_rounded, color: Colors.white)
                                  : null,
                            ),
                            title: Text(
                              playlist.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${playlist.songs.length} songs',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            trailing: isSongInPlaylist
                                ? const Icon(Icons.check_circle, color: AppColors.primary)
                                : const Icon(Icons.add),

                            onTap: isSongInPlaylist
                                ? null
                                : () async {
                              final result = await context.read<MyPlaylistsCubit>().addSongToPlaylist(
                                playlistId: playlist.id,
                                song: song,
                              );

                              if (result == null) {
                                context.pop();
                                _showSnackBar(context, 'Added "${song.title}" to playlist "${playlist.name}"');
                              } else {
                              }
                            },
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}