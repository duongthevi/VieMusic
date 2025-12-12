import 'package:equatable/equatable.dart';

class RemoveSongFromPlaylistReq extends Equatable {
  final String playlistId;
  final String songId;

  const RemoveSongFromPlaylistReq({
    required this.playlistId,
    required this.songId,
  });

  @override
  List<Object?> get props => [playlistId, songId];
}