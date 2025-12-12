import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../domain/entities/artist/artist_entity.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../service_locator.dart';
import '../bloc/search_cubit.dart';
import '../bloc/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchCubit>(),

      child: Builder(
          builder: (innerContext) {

            return Scaffold(
              appBar: BasicAppbar(
                title: _buildSearchField(innerContext),
              ),
              body: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  // 1. Initial state
                  if (state is SearchInitial) {
                    return const Center(
                      child: Text('Type to search for songs, artists...'),
                    );
                  }

                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SearchFailure) {
                    return Center(child: Text(state.message));
                  }

                  if (state is SearchEmpty) {
                    return const Center(child: Text('No results found.'));
                  }

                  // 5. Loaded state
                  if (state is SearchLoaded) {
                    final songs = state.searchResult.songs;
                    final artists = state.searchResult.artists;
                    return _buildResults(context, songs, artists);
                  }

                  return Container();
                },
              ),
            );
          }
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            context.read<SearchCubit>().search('');
          },
        ),
      ),
      onChanged: (query) {
        context.read<SearchCubit>().search(query);
      },
      textInputAction: TextInputAction.search,
    );
  }

  Widget _buildResults(
      BuildContext context,
      List<SongEntity> songs,
      List<ArtistEntity> artists,
      ) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Songs'),
            Tab(text: 'Artists'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSongsTab(context, songs),
              _buildArtistsTab(context, artists),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSongsTab(BuildContext context, List<SongEntity> songs) {
    if (songs.isEmpty) {
      return const Center(child: Text('No songs found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return _buildSongItem(context, songs[index]);
      },
    );
  }

  Widget _buildArtistsTab(BuildContext context, List<ArtistEntity> artists) {
    if (artists.isEmpty) {
      return const Center(child: Text('No artists found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        return _buildArtistItem(context, artists[index]);
      },
    );
  }

  Widget _buildSongItem(BuildContext context, SongEntity song) {
    final artistName = (song.artists?.isNotEmpty ?? false)
        ? song.artists!.first.name
        : 'Unknown Artist';
    final coverUrl = song.album?.coverUrl;

    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade700,
          image: (coverUrl != null && coverUrl.isNotEmpty)
              ? DecorationImage(image: NetworkImage(coverUrl), fit: BoxFit.cover)
              : null,
        ),
        child: (coverUrl == null || coverUrl.isEmpty)
            ? const Icon(Icons.music_note, color: Colors.white)
            : null,
      ),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(artistName, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () {
        final state = context.read<SearchCubit>().state;
        if (state is SearchLoaded) {
          final songs = state.searchResult.songs;
          final initialIndex = songs.indexOf(song);

          context.push(
            '/song-player',
            extra: {
              'queue': songs,
              'initialIndex': initialIndex,
            },
          );
        }
      },
    );
  }

  Widget _buildArtistItem(BuildContext context, ArtistEntity artist) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: (artist.coverUrl.isNotEmpty)
            ? NetworkImage(artist.coverUrl)
            : null,
        child: (artist.coverUrl.isEmpty)
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
      title: Text(artist.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: const Text('Artist'),
      onTap: () {
        context.push('/artist/${artist.id}', extra: artist.id);
      },
    );
  }
}