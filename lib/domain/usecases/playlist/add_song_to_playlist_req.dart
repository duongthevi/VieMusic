// file: add_song_to_playlist_req.dart

import 'package:equatable/equatable.dart';
import '../../../domain/entities/song/song_entity.dart';

class AddSongToPlaylistReq extends Equatable {
  final String playlistId;
  final String songId;
  final SongEntity song;

  const AddSongToPlaylistReq({
    required this.playlistId,
    required this.songId,
    required this.song,
  });

  @override
  List<Object> get props => [playlistId, songId, song];
}