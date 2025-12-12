import 'package:ct312h_project/common/helpers/is_dark_mode.dart';
import 'package:ct312h_project/core/configs/assets/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../widgets/artists_list.dart';
import '../widgets/news_songs.dart';
import '../widgets/playlist_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Key _playlistPreviewKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshPlaylistPreview() {
    setState(() {
      _playlistPreviewKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.person_outline_rounded, color: iconColor, size: 28),
          onPressed: () {
            context.push('/profile');
          },
        ),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 60,
          width: 40,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: iconColor, size: 28),
            onPressed: () {
              context.push('/search');
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _homeTopCard(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  NewsSongs(),
                  ArtistsList(),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _myPlaylistsHeader(context),
            const SizedBox(height: 15),
            PlaylistsPreview(key: _playlistPreviewKey),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _myPlaylistsHeader(BuildContext context) {
    final isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Playlists',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          TextButton(
            onPressed: () async {
              await context.push('/my-playlists');
              _refreshPlaylistPreview();
            },
            child: const Text(
              'See All',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.primary
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: SvgPicture.asset(
                  AppVectors.homeTopCard,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 60,
                ),
                child: Image.asset(
                  AppImages.homeArtist,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    const tabStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: AppColors.primary,
      labelStyle: tabStyle,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      tabs: const [
        Tab(text: 'News'),
        Tab(text: 'Artists'),
      ],
    );
  }
}