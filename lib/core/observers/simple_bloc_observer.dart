import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange (${bloc.runtimeType}): ${change.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError (${bloc.runtimeType})', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}