import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';
import '../../../domain/usecases/artist/get_all_artists.dart';
import 'artist_list_state.dart';

class ArtistsListCubit extends Cubit<ArtistsListState> {
  final GetAllArtistsUseCase _getAllArtistsUseCase = sl<GetAllArtistsUseCase>();

  ArtistsListCubit() : super(ArtistsListLoading());

  void getAllArtists() async {
    log('[ArtistsListCubit] Đang gọi getAllArtists...');
    emit(ArtistsListLoading());
    final result = await _getAllArtistsUseCase();
    result.fold(
          (failure) {
        log('[ArtistsListCubit] Lỗi khi tải nghệ sĩ: $failure');
        emit(ArtistsListFailure(message: failure));
      },
          (artists) {
        log('[ArtistsListCubit] Tải thành công ${artists.length} nghệ sĩ.');
        emit(ArtistsListLoaded(artists: artists));
      },
    );
  }
}