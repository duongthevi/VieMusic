import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../service_locator.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';

import '../../../common/helpers/is_dark_mode.dart';

import 'package:ct312h_project/presentation/playlist/widgets/add_song_to_playlist.dart';

class SongPlayerPage extends StatelessWidget {
  final String songId;
  final List<SongEntity> queue;
  final int initialIndex;

  const SongPlayerPage({
    required this.songId,
    this.queue = const [],
    this.initialIndex = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return BlocProvider(
      create: (_) => sl<SongPlayerCubit>()
        ..loadSongAndDetails(
          songId: songId,
          queue: queue,
          initialIndex: initialIndex,
        ),
      child: BlocBuilder<SongPlayerCubit, SongPlayerState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: BasicAppbar(
              onLeadingPressed: () {
                context.go('/');
              },
              title: Text(
                'PLAYLIST',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: textColor,
                ),
              ),
              action: IconButton(
                onPressed: () {
                  if (state is SongPlayerLoaded) {
                    _showMoreOptions(context, state.song);
                  }
                },
                icon: Icon(Icons.menu, color: secondaryTextColor, size: 28),
              ),
              backgroundColor: backgroundColor,
              leadingIcon: Icons.arrow_back,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, SongPlayerState state) {
    if (state is SongPlayerLoading || state is SongPlayerInitial) {
      return const Center(
        heightFactor: 10,
        child: CircularProgressIndicator(strokeWidth: 4),
      );
    }

    if (state is SongPlayerFailure) {
      return Center(
        heightFactor: 10,
        child: Text(state.message, style: const TextStyle(fontSize: 18)),
      );
    }

    if (state is SongPlayerLoaded) {
      final songEntity = state.song;
      return Column(
        children: [
          _songCover(context, songEntity),
          const SizedBox(height: 50),
          _songDetail(context, songEntity),
          const SizedBox(height: 60),
          _songPlayer(context, state),
        ],
      );
    }

    return Container();
  }

  Widget _songCover(BuildContext context, SongEntity songEntity) {
    final coverUrl = songEntity.album?.coverUrl;
    final isDark = context.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50;

    final Color lightShadow = isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.9);
    final Color darkShadow = isDark ? Colors.black.withOpacity(0.9) : Colors.grey.shade300.withOpacity(0.5);


    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: lightShadow,
              offset: const Offset(-5, -5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: darkShadow,
              offset: const Offset(5, 5),
              blurRadius: 10,
            ),
          ],
          image: (coverUrl != null && coverUrl.isNotEmpty)
              ? DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(coverUrl),
          )
              : null,
        ),
        child: (coverUrl == null || coverUrl.isEmpty)
            ? Center(
            child: Icon(Icons.music_note, color: isDark ? Colors.white60 : Colors.black45, size: 100))
            : null,
      ),
    );
  }

  Widget _songDetail(BuildContext context, SongEntity songEntity) {
    final artistName = (songEntity.artists?.isNotEmpty ?? false)
        ? songEntity.artists!.first.name
        : 'Unknown Artist';
    final isDark = context.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                songEntity.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                artistName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: secondaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        FavoriteButton(songEntity: songEntity, size: 36, isNeumorphic: true)
      ],
    );
  }

  Widget _songPlayer(BuildContext context, SongPlayerLoaded state) {
    final cubit = context.read<SongPlayerCubit>();
    final maxDuration = state.duration.inSeconds.toDouble();
    final primaryColor = AppColors.primary;

    final backgroundColor = context.isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade50;
    final controlIconColor = context.isDarkMode ? Colors.white : Colors.black87;
    final secondaryControlIconColor = context.isDarkMode ? Colors.white70 : Colors.black54;

    final activeColor = primaryColor;
    final inactiveColor = secondaryControlIconColor;

    final shuffleColor = state.isShuffleOn ? activeColor : inactiveColor;

    final bool isRepeatOn = state.loopMode != LoopMode.off;
    final Color repeatColor = isRepeatOn ? activeColor : inactiveColor;
    final IconData repeatIcon = state.loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat;


    if (state.isSongFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cubit.nextSong();
      });
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatDuration(state.position),
              style: TextStyle(color: secondaryControlIconColor, fontSize: 14),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    size: 24,
                    color: shuffleColor,
                  ),
                  onPressed: () {
                    cubit.toggleShuffle();
                  },
                ),
                IconButton(
                  icon: Icon(repeatIcon, size: 24, color: repeatColor),
                  onPressed: () {
                    cubit.toggleRepeat();
                  },
                ),
              ],
            ),
            Text(
              formatDuration(state.duration),
              style: TextStyle(color: secondaryControlIconColor, fontSize: 14),
            ),
          ],
        ),

        SliderTheme(
          data: SliderThemeData(
            trackHeight: 5.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 15.0),
            activeTrackColor: primaryColor,
            inactiveTrackColor: context.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            thumbColor: primaryColor,
          ),
          child: Slider(
            value: state.position.inSeconds.toDouble().clamp(0.0, maxDuration),
            min: 0.0,
            max: maxDuration > 0 ? maxDuration : 1.0,
            onChanged: (value) {
              cubit.seek(Duration(seconds: value.toInt()));
            },
          ),
        ),

        const SizedBox(height: 50),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NeumorphicControl(
              icon: Icons.skip_previous_rounded,
              onPressed: state.isFirstSong ? null : () => cubit.previousSong(),
              backgroundColor: backgroundColor,
              size: 55,
              iconColor: secondaryControlIconColor,
            ),
            const SizedBox(width: 30),

            _NeumorphicControl(
              icon: state.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
              onPressed: () {
                if (state.isPlaying) {
                  cubit.pauseSong();
                } else {
                  cubit.playSong();
                }
              },
              backgroundColor: backgroundColor,
              size: 80,
              iconColor: controlIconColor,
            ),
            const SizedBox(width: 30),

            _NeumorphicControl(
              icon: Icons.skip_next_rounded,
              onPressed: state.isLastSong ? null : () => cubit.nextSong(),
              backgroundColor: backgroundColor,
              size: 55,
              iconColor: secondaryControlIconColor,
            ),
          ],
        ),
      ],
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showMoreOptions(BuildContext context, SongEntity song) {
    final artistName = (song.artists?.isNotEmpty ?? false)
        ? song.artists!.first.name
        : 'Artist';
    final albumName = song.album?.title ?? 'Album';
    final isDark = context.isDarkMode;
    final optionTextColor = isDark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white54 : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.playlist_add_rounded, color: optionTextColor),
                title: Text('Add to Playlist', style: TextStyle(color: optionTextColor, fontSize: 17)),
                onTap: () {
                  context.pop();
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AddSongToPlaylistDialog(song: song),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person_rounded, color: optionTextColor),
                title: Text('View $artistName', style: TextStyle(color: optionTextColor, fontSize: 17)),
                onTap: () {
                  context.pop();
                  if (song.artists?.isNotEmpty ?? false) {
                    context.push('/artist/${song.artists!.first.id}');
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.album_rounded, color: optionTextColor),
                title: Text('View $albumName', style: TextStyle(color: optionTextColor, fontSize: 17)),
                onTap: () {
                  context.pop();
                  if (song.album != null) {
                    context.push('/album/${song.album!.id}');
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.share_rounded, color: optionTextColor),
                title: Text('Share', style: TextStyle(color: optionTextColor, fontSize: 17)),
                onTap: () {
                  context.pop();
                  // TODO: Handle sharing
                },
              ),
              SafeArea(
                child: Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NeumorphicControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double size;
  final Color iconColor;

  const _NeumorphicControl({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    this.size = 55,
    this.iconColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final Color lightShadow = isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.9);
    final Color darkShadow = isDark ? Colors.black.withOpacity(0.9) : Colors.grey.shade300.withOpacity(0.5);
    final disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPressed == null ? disabledColor : backgroundColor,
        boxShadow: [
          BoxShadow(
            color: lightShadow,
            offset: const Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: darkShadow,
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              size: size * 0.5,
              color: onPressed == null ? Colors.grey.shade500 : iconColor,
            ),
          ),
        ),
      ),
    );
  }
}