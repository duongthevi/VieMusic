part of 'playlist_details_cubit.dart';

@immutable
abstract class PlaylistDetailsState extends Equatable {
  const PlaylistDetailsState();

  @override
  List<Object?> get props => [];
}

class PlaylistDetailsInitial extends PlaylistDetailsState {}

class PlaylistDetailsLoading extends PlaylistDetailsState {}

class PlaylistDetailsFailure extends PlaylistDetailsState {
  final String message;
  const PlaylistDetailsFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class PlaylistDetailsLoaded extends PlaylistDetailsState {
  final PlaylistEntity playlist;
  // Sao chép danh sách bài hát ra ngoài để dễ dàng xóa
  final List<SongEntity> songs;

  const PlaylistDetailsLoaded({
    required this.playlist,
    required this.songs,
  });

  @override
  List<Object?> get props => [playlist, songs];

  // Hàm 'copyWith' rất quan trọng để cập nhật UI
  // khi xóa bài hát mà không cần tải lại toàn bộ
  PlaylistDetailsLoaded copyWith({
    PlaylistEntity? playlist,
    List<SongEntity>? songs,
  }) {
    return PlaylistDetailsLoaded(
      playlist: playlist ?? this.playlist,
      songs: songs ?? this.songs,
    );
  }
}