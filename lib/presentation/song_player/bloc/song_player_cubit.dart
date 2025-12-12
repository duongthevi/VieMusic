import 'dart:async';
import 'package:ct312h_project/core/configs/assets/app_images.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'song_player_state.dart';
import 'package:ct312h_project/domain/usecases/song/get_song_details.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer;
  final GetSongDetailsUseCase getSongDetailsUseCase;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _currentIndexSubscription;
  StreamSubscription? _loopModeSubscription; // Thêm subscription cho LoopMode

  List<SongEntity> _currentQueue = [];
  int _currentIndex = 0;
  bool _isShuffleOn = false;


  SongPlayerCubit({
    required this.audioPlayer,
    required this.getSongDetailsUseCase,
  }) : super(SongPlayerInitial());

  Future<void> loadSongAndDetails({
    required String songId,
    List<SongEntity>? queue,
    int? initialIndex,
  }) async {
    await _cancelSubscriptions();

    _isShuffleOn = audioPlayer.shuffleModeEnabled;
    final currentLoopMode = audioPlayer.loopMode;

    try {
      String? currentPlayingId;
      var currentSource = audioPlayer.sequenceState?.currentSource;
      if (currentSource != null && currentSource.tag is MediaItem) {
        currentPlayingId = (currentSource.tag as MediaItem).id;
      }

      if (queue != null && initialIndex != null) {
        _currentQueue = queue;
        _currentIndex = initialIndex;
      }

      final targetSongId = _currentQueue.isNotEmpty
          ? _currentQueue[_currentIndex].id
          : songId;

      final result = await getSongDetailsUseCase(params: targetSongId);

      await result.fold(
            (failureMessage) {
          emit(SongPlayerFailure(message: failureMessage));
        },
            (songEntity) async {
          if (currentPlayingId == targetSongId) {
            if (audioPlayer.currentIndex != null) {
              _currentIndex = audioPlayer.currentIndex!;
            }

            final duration = audioPlayer.duration ?? Duration.zero;
            _listenToStreams(duration);

            emit(
              SongPlayerLoaded(
                song: songEntity,
                position: audioPlayer.position,
                duration: duration,
                isPlaying: audioPlayer.playing,
                queue: _currentQueue,
                currentIndex: _currentIndex,
                isShuffleOn: _isShuffleOn,
                loopMode: currentLoopMode,
              ),
            );
            return;
          }

          emit(SongPlayerLoading());

          final audioSources = _currentQueue.map((s) {
            return AudioSource.uri(
              Uri.parse(s.audioUrl),
              tag: MediaItem(
                id: s.id,
                title: s.title,
                artist: (s.artists?.isNotEmpty ?? false)
                    ? s.artists!.first.name
                    : 'Unknown Artist',
                artUri: s.album?.coverUrl != null
                    ? Uri.parse(s.album!.coverUrl!)
                    : null,
              ),
            );
          }).toList();

          final concatenatedSource =
          ConcatenatingAudioSource(children: audioSources);

          await audioPlayer.setAudioSource(
            concatenatedSource,
            initialIndex: _currentIndex,
            initialPosition: Duration.zero,
          );

          await audioPlayer.setShuffleModeEnabled(_isShuffleOn);

          if (_isShuffleOn) {
            await audioPlayer.shuffle();
          }

          final duration = audioPlayer.duration ?? Duration.zero;
          _listenToStreams(duration);

          emit(
            SongPlayerLoaded(
              song: songEntity,
              position: Duration.zero,
              duration: duration,
              isPlaying: true,
              queue: _currentQueue,
              currentIndex: _currentIndex,
              isShuffleOn: _isShuffleOn,
              loopMode: audioPlayer.loopMode,
            ),
          );

          audioPlayer.play();
        },
      );
    } catch (e) {
      emit(SongPlayerFailure(message: e.toString()));
    }
  }


  void toggleShuffle() async {
    final currentState = state;
    if (currentState is SongPlayerLoaded) {
      final newState = !currentState.isShuffleOn;
      _isShuffleOn = newState;

      await audioPlayer.setShuffleModeEnabled(newState);

      if (newState) {
        await audioPlayer.shuffle();
      }

      // Trạng thái sẽ được cập nhật thông qua stream listener của shuffleModeEnabledStream (trong _listenToStreams)
    }
  }

  void toggleRepeat() async {
    final currentState = state;
    if (currentState is SongPlayerLoaded) {
      final currentMode = currentState.loopMode;
      LoopMode newMode;

      if (currentMode == LoopMode.off) {
        newMode = LoopMode.one; // Tắt -> Lặp lại một bài
      } else if (currentMode == LoopMode.one) {
        newMode = LoopMode.all; // Lặp lại một bài -> Lặp lại toàn bộ
      } else {
        newMode = LoopMode.off; // Lặp lại toàn bộ -> Tắt
      }

      // Áp dụng chế độ lặp lại mới cho JustAudio
      await audioPlayer.setLoopMode(newMode);
      // Trạng thái UI sẽ được cập nhật tự động thông qua loopModeStream
    }
  }

  void togglePlayPause() {
    if (audioPlayer.playing) {
      pauseSong();
    } else {
      playSong();
    }
  }

  Future<void> _updateSongDetails(int newIndex) async {
    if (newIndex < 0 || newIndex >= _currentQueue.length) return;

    _currentIndex = newIndex;
    final targetSongId = _currentQueue[newIndex].id;

    final result = await getSongDetailsUseCase(params: targetSongId);

    result.fold(
          (failureMessage) {
        if (state is SongPlayerLoaded) {
          emit((state as SongPlayerLoaded).copyWith(
            currentIndex: newIndex,
          ));
        } else {
          emit(SongPlayerFailure(message: failureMessage));
        }
      },
          (songEntity) {
        if (state is SongPlayerLoaded) {
          emit((state as SongPlayerLoaded).copyWith(
            song: songEntity,
            currentIndex: newIndex,
            position: Duration.zero,
            duration: audioPlayer.duration,
            isPlaying: true,
          ));
        }
      },
    );
  }

  void nextSong() {
    audioPlayer.seekToNext();
  }

  void previousSong() {
    audioPlayer.seekToPrevious();
  }

  void playSong() {
    if (!audioPlayer.playing) {
      audioPlayer.play();
    }
  }

  void pauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    }
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }


  void _listenToStreams(Duration initialDuration) {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    _loopModeSubscription?.cancel();

    _playerStateSubscription = audioPlayer.playerStateStream.listen((playerState) {
      if (isClosed) return;

      final isPlaying = playerState.playing;
      final isCompleted = playerState.processingState == ProcessingState.completed;
      final currentState = state;

      if (currentState is SongPlayerLoaded) {
        final newState = currentState.copyWith(
          isPlaying: isPlaying,
          isSongFinished: isCompleted && currentState.isLastSong,
        );
        emit(newState);
      }
    });

    _positionSubscription = audioPlayer.positionStream.listen((position) {
      if (isClosed) return;

      final currentState = state;
      if (currentState is SongPlayerLoaded) {
        emit(currentState.copyWith(position: position));
      }
    });

    _durationSubscription = audioPlayer.durationStream.listen((duration) {
      if (isClosed) return;

      final currentState = state;
      if (currentState is SongPlayerLoaded) {
        emit(currentState.copyWith(duration: duration ?? initialDuration));
      }
    });

    _currentIndexSubscription = audioPlayer.currentIndexStream.listen((newIndex) {
      if (isClosed) return;

      final currentState = state;
      if (currentState is SongPlayerLoaded &&
          newIndex != null &&
          newIndex != currentState.currentIndex) {
        _updateSongDetails(newIndex);
      }
    });

    _loopModeSubscription = audioPlayer.loopModeStream.listen((newLoopMode) {
      if (isClosed) return;

      if (state is SongPlayerLoaded) {
        emit((state as SongPlayerLoaded).copyWith(loopMode: newLoopMode));
      }
    });

    audioPlayer.shuffleModeEnabledStream.listen((isEnabled) {
      if (isClosed) return;

      if (state is SongPlayerLoaded) {
        emit((state as SongPlayerLoaded).copyWith(isShuffleOn: isEnabled));
      }
    });
  }
  Future<void> _cancelSubscriptions() async {
    await _playerStateSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _currentIndexSubscription?.cancel();
    await _loopModeSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}