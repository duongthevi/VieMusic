import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/artist/artist_entity.dart';
import '../../../service_locator.dart';
import '../bloc/profile_info_cubit.dart';
import '../bloc/profile_info_state.dart';
import '../bloc/followed_artists_cubit.dart';
import '../bloc/followed_artists_state.dart';

class FollowedArtistsSection extends StatefulWidget {
  const FollowedArtistsSection({super.key});

  @override
  State<FollowedArtistsSection> createState() => _FollowedArtistsSectionState();
}

class _FollowedArtistsSectionState extends State<FollowedArtistsSection> {
  late FollowedArtistsCubit _followedArtistsCubit;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _followedArtistsCubit = sl<FollowedArtistsCubit>();
  }

  @override
  void dispose() {
    _followedArtistsCubit.close();
    super.dispose();
  }

  Future<void> _onArtistTap(BuildContext context, ArtistEntity artist) async {
    await context.push('/artist/${artist.id}');

    if (context.mounted) {
      await context.read<ProfileInfoCubit>().getUser();
    }
  }

  Widget _buildArtistItem(BuildContext context, ArtistEntity artist) {
    return GestureDetector(
      onTap: () => _onArtistTap(context, artist),
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade700,
              backgroundImage: (artist.coverUrl.isNotEmpty)
                  ? NetworkImage(artist.coverUrl)
                  : null,
              child: (artist.coverUrl.isEmpty)
                  ? const Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              artist.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileInfoCubit, ProfileInfoState>(
      listener: (context, state) {
        if (state is ProfileInfoLoaded) {
          final artistIds = state.userEntity.followedArtists ?? [];
          _followedArtistsCubit.loadFollowedArtists(artistIds);
        }
      },
      child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
        builder: (context, profileState) {
          if (profileState is ProfileInfoLoaded && _isFirstLoad) {
            _isFirstLoad = false;
            final artistIds = profileState.userEntity.followedArtists ?? [];
            Future.microtask(() {
              _followedArtistsCubit.loadFollowedArtists(artistIds);
            });
          }

          final List<String> artistIds = (profileState is ProfileInfoLoaded)
              ? profileState.userEntity.followedArtists ?? []
              : [];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ARTISTS YOU FOLLOW',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                if (profileState is ProfileInfoLoading)
                  const Center(child: CircularProgressIndicator()),

                if (profileState is ProfileInfoLoaded && artistIds.isEmpty)
                  const Text('You are not following any artists yet.'),

                if (profileState is ProfileInfoLoaded && artistIds.isNotEmpty)
                  BlocProvider.value(
                    value: _followedArtistsCubit,
                    child: SizedBox(
                      height: 120,
                      child: BlocBuilder<FollowedArtistsCubit, FollowedArtistsState>(
                        builder: (context, artistState) {
                          if (artistState is FollowedArtistsLoading ||
                              artistState is FollowedArtistsInitial) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (artistState is FollowedArtistsLoaded) {
                            final artists = artistState.artists;

                            if (artists.isEmpty) {
                              return const Text('Could not find artist information.');
                            }

                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: artists.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                return _buildArtistItem(context, artists[index]);
                              },
                            );
                          }

                          if (artistState is FollowedArtistsFailure) {
                            return Center(
                              child: Text('Error: ${artistState.message}'),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}