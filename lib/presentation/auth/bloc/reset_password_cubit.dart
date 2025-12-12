import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/auth/reset_password.dart';

// --- State ---
abstract class ResetPasswordState {}
class ResetPasswordInitial extends ResetPasswordState {}
class ResetPasswordLoading extends ResetPasswordState {}
class ResetPasswordSuccess extends ResetPasswordState {}
class ResetPasswordFailure extends ResetPasswordState {
  final String message;
  ResetPasswordFailure(this.message);
}

// --- Cubit ---
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _useCase;

  ResetPasswordCubit(this._useCase) : super(ResetPasswordInitial());

  Future<void> sendResetEmail(String email) async {
    emit(ResetPasswordLoading());
    final result = await _useCase(params: email);
    result.fold(
          (error) => emit(ResetPasswordFailure(error)),
          (_) => emit(ResetPasswordSuccess()),
    );
  }
}