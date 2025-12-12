import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../domain/usecases/playlist/get_playlists.dart';
import '../../../domain/usecases/auth/get_user.dart';

import '../../../domain/usecases/playlist/create_playlist.dart';
import '../../../domain/usecases/playlist/create_playlist_req.dart';

import '../../../domain/usecases/playlist/delete_playlist.dart';
import '../../../domain/usecases/playlist/update_playlist.dart';
import '../../../domain/usecases/playlist/update_playlist_req.dart';
import '../../../domain/usecases/playlist/add_song_to_playlist.dart';
import '../../../domain/usecases/playlist/add_song_to_playlist_req.dart';
import '../../../domain/entities/song/song_entity.dart';

part 'my_playlists_state.dart';

class MyPlaylistsCubit extends Cubit<MyPlaylistsState> {
  final GetPlaylistsUseCase _getPlaylistsUseCase;
  final GetUserUseCase _getUserUseCase;
  final CreatePlaylistUseCase _createPlaylistUseCase;
  final DeletePlaylistUseCase _deletePlaylistUseCase;
  final UpdatePlaylistUseCase _updatePlaylistUseCase;
  final AddSongToPlaylistUseCase _addSongToPlaylistUseCase;

  String? _cachedUserId;

  MyPlaylistsCubit({
    required GetPlaylistsUseCase getPlaylistsUseCase,
    required GetUserUseCase getUserUseCase,
    required CreatePlaylistUseCase createPlaylistUseCase,
    required DeletePlaylistUseCase deletePlaylistUseCase,
    required UpdatePlaylistUseCase updatePlaylistUseCase,
    required AddSongToPlaylistUseCase addSongToPlaylistUseCase,
  })  : _getPlaylistsUseCase = getPlaylistsUseCase,
        _getUserUseCase = getUserUseCase,
        _createPlaylistUseCase = createPlaylistUseCase,
        _deletePlaylistUseCase = deletePlaylistUseCase,
        _updatePlaylistUseCase = updatePlaylistUseCase,
        _addSongToPlaylistUseCase = addSongToPlaylistUseCase,
        super(MyPlaylistsInitial());

  Future<String?> _getCurrentUserId() async {
    if (_cachedUserId != null) return _cachedUserId;

    final userResult = await _getUserUseCase.call();
    _cachedUserId = userResult.fold(
          (_) => null,
          (user) => user.id,
    );
    return _cachedUserId;
  }

  bool isMyPlaylist(PlaylistEntity playlist) {
    return _cachedUserId != null && playlist.ownerId == _cachedUserId;
  }

  Future<bool> isMyPlaylistAsync(PlaylistEntity playlist) async {
    final userId = await _getCurrentUserId();
    return userId != null && playlist.ownerId == userId;
  }

  Future<void> loadPlaylists() async {
    emit(MyPlaylistsLoading());
    try {
      final currentUserId = await _getCurrentUserId();

      final result = await _getPlaylistsUseCase.call();

      result.fold(
            (failureMessage) {
          emit(MyPlaylistsFailure(message: failureMessage));
        },
            (allPlaylists) {
          final List<PlaylistEntity> myPlaylists = [];
          final List<PlaylistEntity> publicPlaylists = [];

          for (var playlist in allPlaylists) {
            if (playlist.ownerId == currentUserId) {
              myPlaylists.add(playlist);
            } else {
              if (playlist.isPublic) {
                publicPlaylists.add(playlist);
              }
            }
          }

          emit(MyPlaylistsLoaded(
            myPlaylists: myPlaylists,
            publicPlaylists: publicPlaylists,
          ));
        },
      );
    } catch (e) {
      emit(MyPlaylistsFailure(message: e.toString()));
    }
  }

  Future<void> loadMyPlaylistsOnly() async {
    if (state is MyPlaylistsLoading) return;

    if (state is! MyPlaylistsLoaded) {
      emit(MyPlaylistsLoading());
    }

    try {
      final currentUserId = await _getCurrentUserId();

      final result = await _getPlaylistsUseCase.call();

      result.fold(
            (failureMessage) {
          emit(MyPlaylistsFailure(message: failureMessage));
        },
            (allPlaylists) {
          final List<PlaylistEntity> myPlaylists = [];

          for (var playlist in allPlaylists) {
            if (playlist.ownerId == currentUserId) {
              myPlaylists.add(playlist);
            }
          }

          final List<PlaylistEntity> publicPlaylists =
          (state is MyPlaylistsLoaded)
              ? (state as MyPlaylistsLoaded).publicPlaylists
              : [];

          emit(MyPlaylistsLoaded(
            myPlaylists: myPlaylists,
            publicPlaylists: publicPlaylists,
          ));
        },
      );
    } catch (e) {
      emit(MyPlaylistsFailure(message: e.toString()));
    }
  }

  Future<void> createPlaylist(CreatePlaylistReq req) async {
    final currentUserId = await _getCurrentUserId();

    if (currentUserId == null) {
      emit(const MyPlaylistsFailure(message: 'Không thể tạo playlist: Người dùng không hợp lệ.'));
      return;
    }

    final CreatePlaylistReq finalReq = CreatePlaylistReq(
      name: req.name,
      ownerId: currentUserId,
      description: req.description,
      isPublic: req.isPublic,
      cover: req.cover,
    );

    final createResult = await _createPlaylistUseCase.call(params: finalReq);

    createResult.fold(
          (failureMessage) {
        emit(MyPlaylistsFailure(message: failureMessage));
      },
          (_) {
        loadPlaylists();
      },
    );
  }

  Future<void> deletePlaylist(String playlistId) async {
    final deleteResult = await _deletePlaylistUseCase.call(params: playlistId);

    deleteResult.fold(
          (failureMessage) {
        emit(MyPlaylistsFailure(message: failureMessage));
      },
          (_) {
        loadPlaylists();
      },
    );
  }

  Future<void> updatePlaylist(UpdatePlaylistReq req) async {
    final updateResult = await _updatePlaylistUseCase.call(params: req);

    updateResult.fold(
          (failureMessage) {
        emit(MyPlaylistsFailure(message: failureMessage));
      },
          (_) {
        loadPlaylists();
      },
    );
  }

  Future<String?> addSongToPlaylist({
    required String playlistId,
    required SongEntity song,
  }) async {
    final AddSongToPlaylistReq req = AddSongToPlaylistReq(
      playlistId: playlistId,
      songId: song.id,
      song: song,
    );

    final addResult = await _addSongToPlaylistUseCase.call(params: req);

    return addResult.fold(
          (failureMessage) {
        return failureMessage;
      },
          (_) {
        loadPlaylists();
        return null;
      },
    );
  }
}