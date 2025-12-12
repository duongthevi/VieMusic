import 'package:ct312h_project/common/helpers/is_dark_mode.dart';
import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/artist_list_cubit.dart';
import '../bloc/artist_list_state.dart';

class ArtistsList extends StatelessWidget {
  const ArtistsList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;

    return BlocProvider(
      create: (_) => ArtistsListCubit()..getAllArtists(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
            child: Text(
              'Popular artists',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          SizedBox(
            height: 200,
            child: BlocBuilder<ArtistsListCubit, ArtistsListState>(
              builder: (context, state) {
                if (state is ArtistsListLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? Colors.white70 : Colors.blueAccent,
                      ),
                    ),
                  );
                }

                if (state is ArtistsListLoaded) {
                  if (state.artists.isEmpty) {
                    return const Center(
                      child: Text(
                        'No artists found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return _artists(context, state.artists);
                }

                if (state is ArtistsListFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Failed to load artists: ${state.message}',
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _artists(BuildContext context, List<ArtistEntity> artists) {
    final isDark = context.isDarkMode;
    final placeholderColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.grey : Colors.black54;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        final artist = artists[index];
        final coverUrl = artist.coverUrl;

        return SizedBox(
          width: 110,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              context.push('/artist/${artist.id}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: placeholderColor,
                  backgroundImage: (coverUrl.isNotEmpty)
                      ? NetworkImage(coverUrl)
                      : null,
                  child: (coverUrl.isEmpty)
                      ? const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 50,
                  )
                      : null,
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    artist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),

                Text(
                  'Artist',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemCount: artists.length,
    );
  }
}