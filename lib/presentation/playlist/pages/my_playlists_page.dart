import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../service_locator.dart';
import '../bloc/my_playlists_cubit.dart';

import '../widgets/create_playlist.dart';
import '../widgets/update_playlist.dart';

class MyPlaylistsPage extends StatefulWidget {
  const MyPlaylistsPage({super.key});

  @override
  State<MyPlaylistsPage> createState() => _MyPlaylistsPageState();
}

class _MyPlaylistsPageState extends State<MyPlaylistsPage> {
  late MyPlaylistsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MyPlaylistsCubit>()..loadPlaylists();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _refreshPlaylists() {
    _cubit.loadPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: BasicAppbar(
          title: const Text('Playlists'),
          onLeadingPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showCreatePlaylistDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showCreatePlaylistDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: const CreatePlaylistDialog(),
        );
      },
    );
    _refreshPlaylists();
  }

  Future<void> _showPlaylistOptions(BuildContext context, PlaylistEntity playlist) async {
    await showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit playlist'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showEditPlaylistDialog(context, playlist);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red.shade700),
              title: Text('Delete playlist', style: TextStyle(color: Colors.red.shade700)),
              onTap: () {
                Navigator.pop(sheetContext);
                _showDeleteConfirmation(context, playlist);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, PlaylistEntity playlist) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the playlist "${playlist.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _cubit.deletePlaylist(playlist.id);
      _refreshPlaylists();
    }
  }

  Future<void> _showEditPlaylistDialog(BuildContext context, PlaylistEntity playlist) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _cubit,
          child: EditPlaylistDialog(playlist: playlist),
        );
      },
    );
    _refreshPlaylists();
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
                _buildPlaylistList(context, state.myPlaylists, isMyPlaylist: true),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Public Playlists'),
                _buildPlaylistList(context, state.publicPlaylists, isMyPlaylist: false),
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

  Widget _buildPlaylistList(BuildContext context, List<PlaylistEntity> playlists, {bool isMyPlaylist = false}) {
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
          onTap: () async {
            await context.push('/playlist-details/${playlist.id}');
            _refreshPlaylists();
          },
          onLongPress: () {
            if (isMyPlaylist) {
              _showPlaylistOptions(context, playlist);
            }
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
                if (isMyPlaylist)
                  const Icon(Icons.more_vert_rounded)
                else
                  const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        );
      },
    );
  }
}