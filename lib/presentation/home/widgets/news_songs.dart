import 'package:ct312h_project/common/helpers/is_dark_mode.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/news_songs_cubit.dart';
import '../bloc/news_songs_state.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
          height: 200,
          child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
            builder: (context, state) {
              if (state is NewsSongsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is NewsSongsLoaded) {
                if (state.songs.isEmpty) {
                  return const Center(
                    child: Text('No new songs available.'),
                  );
                }
                return _songs(context, state.songs);
              }

              if (state is NewsSongsFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Container();
            },
          )),
    );
  }

  Widget _songs(BuildContext context, List<SongEntity> songs) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final song = songs[index];

        final artistName = (song.artists?.isNotEmpty ?? false)
            ? song.artists!.first.name
            : 'Unknown Artist';

        final songImage = AppImages.musicCover;

        return GestureDetector(
          onTap: () {
            final List<SongEntity> songListQueue = songs;

            context.push(
              '/song-player',
              extra: {
                'queue': songListQueue,
                'initialIndex': index,
              },
            );
          },
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: context.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      image: (songImage != null && songImage.isNotEmpty)
                          ? DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(songImage),
                      )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        if (songImage == null || songImage.isEmpty)
                          const Center(
                            child: Icon(
                              Icons.music_note_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 40,
                            width: 40,
                            transform: Matrix4.translationValues(10, 10, 0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.isDarkMode
                                  ? AppColors.darkGrey
                                  : const Color(0xffE6E6E6),
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: context.isDarkMode
                                  ? const Color(0xff959595)
                                  : const Color(0xff555555),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 14),
      itemCount: songs.length,
    );
  }
}