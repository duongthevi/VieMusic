import 'package:ct312h_project/data/models/artist/artist_model.dart';
import 'package:ct312h_project/data/models/song/song_model.dart';
import 'package:dartz/dartz.dart';

abstract class ArtistDataSource {
  Future<Either<String, List<ArtistModel>>> getAllArtists();

  Future<Either<String, ArtistModel>> getArtist(String artistId);

  Future<Either<String, List<SongModel>>> getArtistSongs(String artistId);

  Future<Either<String, List<ArtistModel>>> getArtistsByIds(List<String> artistIds);
}