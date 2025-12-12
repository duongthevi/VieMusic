import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/album/album_entity.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../domain/usecases/album/get_album_details.dart';
import '../../../domain/usecases/song/get_album_songs.dart';

part 'album_details_state.dart';

class AlbumDetailsCubit extends Cubit<AlbumDetailsState> {
  final GetAlbumDetailsUseCase _getAlbumDetailsUseCase;
  final GetAlbumSongsUseCase _getAlbumSongsUseCase;

  AlbumDetailsCubit({
    required GetAlbumDetailsUseCase getAlbumDetailsUseCase,
    required GetAlbumSongsUseCase getAlbumSongsUseCase,
  })  : _getAlbumDetailsUseCase = getAlbumDetailsUseCase,
        _getAlbumSongsUseCase = getAlbumSongsUseCase,
        super(AlbumDetailsInitial());

  Future<void> loadAlbumDetails(String albumId) async {
    emit(AlbumDetailsLoading());
    try {
      // Gọi song song 2 UseCase
      final results = await Future.wait([
        _getAlbumDetailsUseCase(params: albumId),
        _getAlbumSongsUseCase(params: albumId),
      ]);

      // Xử lý kết quả 1 (Either<String, AlbumEntity>)
      final albumResult = results[0] as Either<String, AlbumEntity>;

      // Xử lý kết quả 2 (Either<String, List<SongEntity>>)
      final songsResult = results[1] as Either<String, List<SongEntity>>;

      // Fold để lấy giá trị hoặc báo lỗi
      await albumResult.fold(
            (failureMessage) {
          emit(AlbumDetailsFailure(message: failureMessage));
        },
            (album) async {
          await songsResult.fold(
                (failureMessage) {
              emit(AlbumDetailsFailure(message: failureMessage));
            },
                (songs) {
              emit(AlbumDetailsLoaded(album: album, songs: songs));
            },
          );
        },
      );
    } catch (e) {
      emit(AlbumDetailsFailure(message: e.toString()));
    }
  }
}