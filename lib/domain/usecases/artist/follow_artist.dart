// domain/usecases/artist/follow_artist.dart
import 'package:ct312h_project/domain/repository/artist/artist_repository.dart';
import 'package:dartz/dartz.dart';

class FollowArtistUseCase {
  final ArtistRepository repository;

  FollowArtistUseCase(this.repository);

  /// Thêm ID nghệ sĩ vào danh sách theo dõi của người dùng.
  /// Trả về Unit (thành công) hoặc thông báo lỗi (String).
  Future<Either<String, Unit>> call(String artistId) {
    return repository.followArtist(artistId);
  }
}