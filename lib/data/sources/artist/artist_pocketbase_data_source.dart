import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:ct312h_project/data/models/artist/artist_model.dart';
import 'package:ct312h_project/data/models/song/song_model.dart';
import 'package:ct312h_project/data/sources/base_data_source.dart';
import 'package:dartz/dartz.dart';

import 'artist_data_source.dart';

class ArtistPocketBaseDataSource extends BasePocketBaseDataSource
    implements ArtistDataSource {
  ArtistPocketBaseDataSource(super._client);

  List<String> _getLikedSongIds() {
    final user = pb.authStore.model;
    if (user == null) {
      return <String>[];
    }
    final likedTracks = user.data['liked_tracks'] as List<dynamic>?;
    return likedTracks?.map((id) => id.toString()).toList() ?? <String>[];
  }

  @override
  Future<Either<String, ArtistModel>> getArtist(String artistId) async {
    return await tryCatchWrapper(() async {
      final record = await pb
          .collection(PbConstants.artistsCollection)
          .getOne(artistId);
      return ArtistModel.fromJson(record.toJson());
    });
  }

  @override
  Future<Either<String, List<ArtistModel>>> getAllArtists() async {
    return await tryCatchWrapper(() async {
      final result =
      await pb.collection(PbConstants.artistsCollection).getFullList(
        sort: 'name',
      );

      return result
          .map((record) => ArtistModel.fromJson(record.toJson()))
          .toList();
    });
  }

  @override
  Future<Either<String, List<SongModel>>> getArtistSongs(
      String artistId) async {
    return await tryCatchWrapper(() async {
      final likedSongIds = _getLikedSongIds();

      final result =
      await pb.collection(PbConstants.songsCollection).getFullList(
        filter: "artists ~ '$artistId'",
        sort: '-release_date',
        expand: 'album,artists',
      );

      final songs = SongModel.mapRecordsToModels(
        records: result,
        likedSongIds: likedSongIds,
      );

      return songs;
    });
  }

  @override
  Future<Either<String, List<ArtistModel>>> getArtistsByIds(
      List<String> artistIds) async {
    return await tryCatchWrapper(() async {
      if (artistIds.isEmpty) {
        return <ArtistModel>[];
      }

      final filterString = artistIds.map((id) => 'id="$id"').join(' || ');

      final result = await pb
          .collection(PbConstants.artistsCollection)
          .getList(
        filter: filterString,
        perPage: artistIds.length,
      );

      return result.items
          .map((record) => ArtistModel.fromJson(record.toJson()))
          .toList();
    });
  }
}