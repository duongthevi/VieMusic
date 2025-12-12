import 'package:ct312h_project/domain/entities/artist/artist_entity.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ArtistRepository {
  Future<Either<String, List<ArtistEntity>>> getAllArtists();
  Future<Either<String, ArtistEntity>> getArtist(String artistId);
  Future<Either<String, List<SongEntity>>> getArtistSongs(String artistId);
  Future<Either<String, List<ArtistEntity>>> getArtistsByIds(List<String> artistIds);
  Future<Either<String, bool>> isArtistFollowed(String artistId);
  Future<Either<String, Unit>> followArtist(String artistId);
  Future<Either<String, Unit>> unfollowArtist(String artistId);
}