import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../domain/entities/album/album_entity.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../service_locator.dart';
import 'package:ct312h_project/presentation/album/bloc/album_details_cubit.dart';

class AlbumDetailsPage extends StatelessWidget {
  final String albumId;
  const AlbumDetailsPage({
    required this.albumId,
    super.key,
  });

  void _startPlaying(
      BuildContext context,
      List<SongEntity> songs, {
        required int initialIndex,
      }) {
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


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AlbumDetailsCubit>()..loadAlbumDetails(albumId),
      child: BlocBuilder<AlbumDetailsCubit, AlbumDetailsState>(
        builder: (context, state) {
          final String title =
          (state is AlbumDetailsLoaded) ? state.album.title : 'Album';

          return Scaffold(
            appBar: BasicAppbar(
              onLeadingPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
              title: Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AlbumDetailsState state) {
    if (state is AlbumDetailsLoading || state is AlbumDetailsInitial) {
      return const Center(
        heightFactor: 10,
        child: CircularProgressIndicator(),
      );
    }

    if (state is AlbumDetailsFailure) {
      return Center(
        heightFactor: 10,
        child: Text(state.message),
      );
    }

    if (state is AlbumDetailsLoaded) {
      final album = state.album;
      final songs = state.songs;

      return Column(
        children: [
          _buildAlbumHeader(context, album, songs),
          const SizedBox(height: 30),
          _buildSongList(context, songs),
        ],
      );
    }

    return Container();
  }

  Widget _buildAlbumHeader(
      BuildContext context, AlbumEntity album, List<SongEntity> songs) {
    final coverUrl = album.coverUrl;
    final bool hasCover = coverUrl != null && coverUrl.isNotEmpty;
    final artistName = (album.artists?.isNotEmpty ?? false)
        ? album.artists!.first.name
        : 'Unknown Artist';

    final canPlay = songs.isNotEmpty;

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.7,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
              : const Icon(Icons.album, size: 80, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          album.title,
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
          'Album by $artistName',
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        if (canPlay)
          GestureDetector(
            onTap: () {
              _startPlaying(context, songs, initialIndex: 0);
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
    );
  }

  Widget _buildSongList(BuildContext context, List<SongEntity> songs) {
    if (songs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('This album has no songs yet.'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final song = songs[index];
        final artistName = (song.artists?.isNotEmpty ?? false)
            ? song.artists!.map((a) => a.name).join(', ')
            : 'Unknown Artist';

        return GestureDetector(
          onTap: () {
            _startPlaying(context, songs, initialIndex: index);
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
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            artistName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 11),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text(
                _formatDuration(Duration(seconds: song.duration.toInt())),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}