import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../service_locator.dart';
import '../bloc/playlist_details_cubit.dart';
import '../bloc/my_playlists_cubit.dart';
import '../widgets/update_playlist.dart';

class PlaylistDetailsPage extends StatefulWidget {
  final String playlistId;
  const PlaylistDetailsPage({
    required this.playlistId,
    super.key,
  });

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  late PlaylistDetailsCubit _detailsCubit;
  late MyPlaylistsCubit _myPlaylistsCubit;
  bool? _isOwner;

  @override
  void initState() {
    super.initState();
    _detailsCubit = sl<PlaylistDetailsCubit>()..loadPlaylist(widget.playlistId);
    _myPlaylistsCubit = sl<MyPlaylistsCubit>();
    _checkOwnership();
  }

  @override
  void dispose() {
    _detailsCubit.close();
    super.dispose();
  }

  Future<void> _checkOwnership() async {
    await _myPlaylistsCubit.loadPlaylists();
  }

  void _startPlaying(List<SongEntity> songs, {required int initialIndex}) {
    if (songs.isNotEmpty) {
      context.push(
        '/song-player',
        extra: {
          'queue': songs,
          'initialIndex': initialIndex,
        },
      );
    }
  }

  Future<void> _handleDeletePlaylist(PlaylistEntity playlist) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Playlist Deletion'),
          content: Text('Are you sure you want to permanently delete the playlist "${playlist.name}"?'),
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

    if (confirmed == true && mounted) {
      await _myPlaylistsCubit.deletePlaylist(playlist.id);
      if (mounted) {
        context.go('/my-playlists');
      }
    }
  }

  Future<void> _showEditPlaylistDialog(PlaylistEntity playlist) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: _myPlaylistsCubit,
          child: EditPlaylistDialog(playlist: playlist),
        );
      },
    );
    if (mounted) {
      _detailsCubit.loadPlaylist(playlist.id);
    }
  }

  void _showMoreOptions(PlaylistDetailsLoaded state, bool isOwner) {
    showModalBottomSheet(
      context: context,
      builder: (modalContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOwner)
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: const Text('Edit Playlist'),
                onTap: () {
                  Navigator.pop(modalContext);
                  _showEditPlaylistDialog(state.playlist);
                },
              ),
            if (isOwner)
              ListTile(
                leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                title: const Text('Delete Playlist', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(modalContext);
                  _handleDeletePlaylist(state.playlist);
                },
              ),
            if (!isOwner)
              ListTile(
                leading: const Icon(Icons.share_rounded),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(modalContext);
                },
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _detailsCubit,
      child: BlocBuilder<PlaylistDetailsCubit, PlaylistDetailsState>(
        builder: (context, state) {
          final String title =
          (state is PlaylistDetailsLoaded) ? state.playlist.name : 'Playlist';

          final bool isOwner = (state is PlaylistDetailsLoaded)
              ? _myPlaylistsCubit.isMyPlaylist(state.playlist)
              : false;

          return Scaffold(
            appBar: BasicAppbar(
              onLeadingPressed: () {
                if (context.canPop()) {
                  context.pop(true);
                } else {
                  context.go('/my-playlists');
                }
              },
              title: Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              action: IconButton(
                onPressed: () {
                  if (state is PlaylistDetailsLoaded) {
                    _showMoreOptions(state, isOwner);
                  }
                },
                icon: const Icon(Icons.more_vert),
              ),
            ),
            body: _buildBody(state, isOwner),
          );
        },
      ),
    );
  }

  Widget _buildBody(PlaylistDetailsState state, bool isOwner) {
    if (state is PlaylistDetailsLoading || state is PlaylistDetailsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PlaylistDetailsFailure) {
      return Center(child: Text('Error: ${state.message}'));
    }

    if (state is PlaylistDetailsLoaded) {
      final playlist = state.playlist;
      final songs = state.songs;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            _buildPlaylistHeader(playlist, songs),
            const SizedBox(height: 30),
            _buildSongList(playlist.songs, isOwner),
          ],
        ),
      );
    }

    return Container();
  }

  Widget _buildPlaylistHeader(PlaylistEntity playlist, List<SongEntity> songs) {
    final coverUrl = playlist.coverUrl;
    final bool hasCover = coverUrl.isNotEmpty;
    final ownerInfo = 'ID: ${playlist.ownerId}';
    final canPlay = songs.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
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
                : const Icon(Icons.queue_music_rounded, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            playlist.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            playlist.description.isNotEmpty
                ? playlist.description
                : 'Created by $ownerInfo',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (canPlay)
            GestureDetector(
              onTap: () {
                _startPlaying(songs, initialIndex: 0);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'PLAY ALL',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSongList(List<SongEntity> songs, bool isOwner) {
    if (songs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('This playlist has no songs yet.'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: songs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final song = songs[index];
        final artistName = (song.artists?.isNotEmpty ?? false)
            ? song.artists!.map((a) => a.name).join(', ')
            : 'Unknown Artist';

        return GestureDetector(
          onTap: () {
            _startPlaying(songs, initialIndex: index);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            artistName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (isOwner)
                IconButton(
                  onPressed: () {
                    _detailsCubit.removeSongAt(index);
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}