import 'package:equatable/equatable.dart';
import 'package:ct312h_project/domain/entities/song/song_entity.dart';
import 'package:just_audio/just_audio.dart';

abstract class SongPlayerState extends Equatable {
  const SongPlayerState();

  @override
  List<Object?> get props => [];
}

class SongPlayerInitial extends SongPlayerState {}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerFailure extends SongPlayerState {
  final String message;
  const SongPlayerFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class SongPlayerLoaded extends SongPlayerState {
  final SongEntity song;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final List<SongEntity> queue;
  final int currentIndex;
  final bool isSongFinished;
  final bool isShuffleOn;
  final LoopMode loopMode;

  const SongPlayerLoaded({
    required this.song,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.queue,
    required this.currentIndex,
    this.isSongFinished = false,
    this.isShuffleOn = false,
    this.loopMode = LoopMode.off,
  });

  bool get isFirstSong => currentIndex == 0;
  bool get isLastSong => currentIndex == queue.length - 1;


  SongPlayerLoaded copyWith({
    SongEntity? song,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    List<SongEntity>? queue,
    int? currentIndex,
    bool? isSongFinished,
    bool? isShuffleOn,
    LoopMode? loopMode,
  }) {
    return SongPlayerLoaded(
      song: song ?? this.song,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isSongFinished: isSongFinished ?? this.isSongFinished,
      isShuffleOn: isShuffleOn ?? this.isShuffleOn,
      loopMode: loopMode ?? this.loopMode,
    );
  }

  @override
  List<Object?> get props => [
    song,
    position,
    duration,
    isPlaying,
    queue,
    currentIndex,
    isSongFinished,
    isShuffleOn,
    loopMode
  ];
}