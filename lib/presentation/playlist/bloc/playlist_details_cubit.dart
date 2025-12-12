import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../domain/entities/song/song_entity.dart';

import '../../../domain/usecases/playlist/get_playlist_by_id.dart';
import '../../../domain/usecases/playlist/remove_song_from_playlist.dart';

import '../../../domain/usecases/playlist/remove_song_from_playlist_req.dart';

part 'playlist_details_state.dart';

class PlaylistDetailsCubit extends Cubit<PlaylistDetailsState> {
  final GetPlaylistByIdUseCase _getPlaylistByIdUseCase;
  final RemoveSongFromPlaylistUseCase _removeSongFromPlaylistUseCase;

  PlaylistDetailsCubit({
    required GetPlaylistByIdUseCase getPlaylistByIdUseCase,
    required RemoveSongFromPlaylistUseCase removeSongFromPlaylistUseCase,
  })  : _getPlaylistByIdUseCase = getPlaylistByIdUseCase,
        _removeSongFromPlaylistUseCase = removeSongFromPlaylistUseCase,
        super(PlaylistDetailsInitial());

  Future<void> loadPlaylist(String playlistId) async {
    emit(PlaylistDetailsLoading());
    try {
      final result = await _getPlaylistByIdUseCase(params: playlistId);

      result.fold(
            (failureMessage) {
          emit(PlaylistDetailsFailure(message: failureMessage));
        },
            (playlist) {
          emit(PlaylistDetailsLoaded(
            playlist: playlist,
            songs: List<SongEntity>.from(playlist.songs),
          ));
        },
      );
    } catch (e) {
      emit(PlaylistDetailsFailure(message: e.toString()));
    }
  }

  Future<void> removeSongAt(int index) async {
    if (state is PlaylistDetailsLoaded) {
      final currentState = state as PlaylistDetailsLoaded;
      final playlistId = currentState.playlist.id;

      final songToRemove = currentState.songs[index];

      final updatedSongs = List<SongEntity>.from(currentState.songs)
        ..removeAt(index);

      emit(currentState.copyWith(songs: updatedSongs));

      final params = RemoveSongFromPlaylistReq(
        playlistId: playlistId,
        songId: songToRemove.id,
      );

      final result = await _removeSongFromPlaylistUseCase.call(params: params);

      result.fold(
            (failure) {
          emit(currentState.copyWith(songs: currentState.songs));
          // TODO: Hiển thị snackbar báo lỗi (ví dụ: "Xóa thất bại")
        },
            (_) async {
              await loadPlaylist(playlistId);
        },
      );
    }
  }
}