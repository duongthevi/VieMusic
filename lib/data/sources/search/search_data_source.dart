import 'package:ct312h_project/data/models/artist/artist_model.dart';
import 'package:ct312h_project/data/models/song/song_model.dart';
import 'package:dartz/dartz.dart';

abstract class SearchDataSource {
  Future<Either<String, (List<SongModel>, List<ArtistModel>)>> search(
      String query);
}