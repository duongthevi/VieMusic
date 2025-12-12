import 'package:dartz/dartz.dart';

import '../../../../core/configs/constants/pocketbase_constants.dart';
import '../../../../data/models/artist/artist_model.dart'; // Giả định bạn có file này
import '../../../../data/models/song/song_model.dart';
import '../base_data_source.dart'; // Giả định bạn có file base này
import 'search_data_source.dart';

class SearchPocketBaseDataSource extends BasePocketBaseDataSource
    implements SearchDataSource {
  SearchPocketBaseDataSource(super._client);

  /// Helper private để lấy danh sách ID các bài hát đã thích của user hiện tại.
  /// Sao chép từ [SongPocketBaseDataSource] để đảm bảo [SongModel]
  /// được tạo ra với trường [isFavorite] chính xác.
  List<String> _getLikedSongIds() {
    final user = pb.authStore.model;
    if (user == null) {
      return <String>[];
    }
    final likedTracks = user.data['liked_tracks'] as List<dynamic>?;
    return likedTracks?.map((id) => id.toString()).toList() ?? <String>[];
  }

  @override
  Future<Either<String, (List<SongModel>, List<ArtistModel>)>> search(
      String query) async {
    // Sử dụng tryCatchWrapper để xử lý lỗi nhất quán
    return await tryCatchWrapper(() async {
      // 1. Lấy danh sách liked songs để gán cờ isFavorite
      final likedSongIds = _getLikedSongIds();

      // 2. Tạo filter cho PocketBase (sử dụng toán tử `~` nghĩa là "contains")
      // Thêm dấu ' để tránh lỗi SQL injection (PocketBase sẽ xử lý)
      final filterQuery = "'$query'";
      final songFilter = 'title~$filterQuery';
      final artistFilter = 'name~$filterQuery';

      // 3. Gọi API tìm kiếm Bài hát (Songs)
      final songsResult =
      await pb.collection(PbConstants.songsCollection).getList(
        filter: songFilter,
        expand: 'album,artists', // Mở rộng quan hệ
      );

      final songs = SongModel.mapRecordsToModels(
        records: songsResult.items,
        likedSongIds: likedSongIds,
      );

      // 4. Gọi API tìm kiếm Nghệ sĩ (Artists)
      // Giả định bạn có 'artistsCollection' trong PbConstants
      final artistsResult =
      await pb.collection(PbConstants.artistsCollection).getList(
        filter: artistFilter,
      );

      // Giả định ArtistModel có phương thức tương tự
      final artists = ArtistModel.mapRecordsToModels(
        records: artistsResult.items,
      );

      // 5. Trả về kết quả dưới dạng một tuple
      return (songs, artists);
    });
  }
}