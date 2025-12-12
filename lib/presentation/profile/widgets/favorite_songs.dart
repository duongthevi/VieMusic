import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../service_locator.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../bloc/favorite_songs_cubit.dart';
import '../bloc/favorite_songs_state.dart';

class FavoriteSongsSection extends StatelessWidget {
  const FavoriteSongsSection({super.key});

  String _formatDuration(num secondsNum) {
    try {
      final int totalSeconds = secondsNum.toInt();
      final duration = Duration(seconds: totalSeconds);

      final String minutes =
      duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final String seconds =
      duration.inSeconds.remainder(60).toString().padLeft(2, '0');

      return '$minutes:$seconds';
    } catch (e) {
      return '00:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FavoriteSongsCubit>()..getFavoriteSongs(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FAVORITE SONGS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
              builder: (context, state) {
                if (state is FavoriteSongsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FavoriteSongsLoaded) {
                  final songs = state.favoriteSongs;
                  if (songs.isEmpty) {
                    return const Center(
                      child: Text('You have no favorite songs yet.'),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final song = songs[index];

                      final artistName = (song.artists?.isNotEmpty ?? false)
                          ? song.artists!.first.name
                          : 'Unknown Artist';

                      final coverUrl = song.album?.coverUrl;

                      return GestureDetector(
                        onTap: () {
                          final List<SongEntity> songQueue = songs;
                          context.push(
                            '/song-player',
                            extra: {
                              'queue': songQueue,
                              'initialIndex': index,
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.shade400,
                                      image: (coverUrl != null &&
                                          coverUrl.isNotEmpty)
                                          ? DecorationImage(
                                        image: NetworkImage(coverUrl),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                    ),
                                    child: (coverUrl == null ||
                                        coverUrl.isEmpty)
                                        ? const Icon(Icons.music_note,
                                        color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          song.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          artistName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  _formatDuration(song.duration),
                                ),
                                const SizedBox(width: 20),
                                FavoriteButton(
                                  songEntity: song,
                                  key: UniqueKey(),
                                  function: () {
                                    context
                                        .read<FavoriteSongsCubit>()
                                        .removeSong(index);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                    itemCount: songs.length,
                  );
                }

                if (state is FavoriteSongsFailure) {
                  return Center(
                    child: Text(
                      state.message ?? 'Could not load favorite songs list.',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}