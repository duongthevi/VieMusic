import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_state.dart';
import 'package:ct312h_project/domain/usecases/search/search_usecase.dart';

import '../../../service_locator.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}

class SearchCubit extends Cubit<SearchState> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  SearchCubit() : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _debouncer.cancel();
      emit(SearchInitial());
      return;
    }

    _debouncer.run(() async {
      emit(SearchLoading());

      var result = await sl<SearchUseCase>().call(params: query);

      result.fold(
            (failureMessage) {
          emit(SearchFailure(message: failureMessage));
        },
            (searchResult) {
          if (searchResult.isEmpty) {
            emit(SearchEmpty());
          } else {
            emit(SearchLoaded(searchResult: searchResult));
          }
        },
      );
    });
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}