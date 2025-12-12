import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../domain/entities/artist/artist_entity.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../service_locator.dart';
import 'package:ct312h_project/presentation/artist/bloc/artist_details_cubit.dart';

class ArtistDetailsPage extends StatelessWidget {
  final String artistId;
  const ArtistDetailsPage({
    required this.artistId,
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
      create: (_) => sl<ArtistDetailsCubit>()..loadArtistDetails(artistId),
      child: BlocBuilder<ArtistDetailsCubit, ArtistDetailsState>(
        builder: (context, state) {
          final String title =
          (state is ArtistDetailsLoaded) ? state.artist.name : 'Artist';

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

  Widget _buildBody(BuildContext context, ArtistDetailsState state) {

    if (state is ArtistDetailsLoading || state is ArtistDetailsInitial) {
      return const Center(
        heightFactor: 10,
        child: CircularProgressIndicator(),
      );
    }

    if (state is ArtistDetailsFailure) {
      return Center(
        heightFactor: 10,
        child: Text(state.message),
      );
    }

    if (state is ArtistDetailsLoaded) {
      final artist = state.artist;
      final songs = state.songs;
      final isFollowed = state.isFollowed;

      return Column(
        children: [
          _buildArtistHeader(context, artist, songs, isFollowed),
          const SizedBox(height: 30),
          _buildSongList(context, songs),
        ],
      );
    }

    return Container();
  }

  Widget _buildArtistHeader(
      BuildContext context,
      ArtistEntity artist,
      List<SongEntity> songs,
      bool isFollowed,
      ) {
    final coverUrl = artist.coverUrl;
    final canPlay = songs.isNotEmpty;
    final cubit = context.read<ArtistDetailsCubit>();

    return Column(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.grey.shade700,
          backgroundImage: (coverUrl.isNotEmpty)
              ? NetworkImage(coverUrl)
              : null,
          child: (coverUrl.isEmpty)
              ? const Icon(Icons.person, size: 80, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          artist.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

            if (canPlay) const SizedBox(width: 10),

            GestureDetector(
              onTap: () {
                cubit.toggleFollowArtist(artist.id);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  color: isFollowed ? Colors.white : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: isFollowed ? Colors.green : Colors.grey.shade700),
                ),
                child: Text(
                  isFollowed ? 'FOLLOWING' : 'FOLLOW',
                  style: TextStyle(
                    color: isFollowed ? Colors.green : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
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
          child: Text('This artist has no songs yet.'),
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
        final albumName = song.album?.title ?? 'Unknown Album';

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
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade700,
                        image: (song.album?.coverUrl != null &&
                            song.album!.coverUrl.isNotEmpty)
                            ? DecorationImage(
                          image: NetworkImage(song.album!.coverUrl),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: (song.album?.coverUrl == null ||
                          song.album!.coverUrl.isEmpty)
                          ? const Icon(Icons.music_note, size: 24)
                          : null,
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
                            albumName,
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
                formatDuration(Duration(seconds: song.duration.toInt())),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}