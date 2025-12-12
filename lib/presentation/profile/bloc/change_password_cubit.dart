import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/auth/change_password.dart';
import '../../../../domain/usecases/auth/change_password_req.dart';
import '../../../../service_locator.dart';
import '../../../core/database/pocketbase_client.dart';

abstract class ChangePasswordState {}
class ChangePasswordInitial extends ChangePasswordState {}
class ChangePasswordLoading extends ChangePasswordState {}
class ChangePasswordSuccess extends ChangePasswordState {}
class ChangePasswordFailure extends ChangePasswordState {
  final String message;
  ChangePasswordFailure(this.message);
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());

    final result = await sl<ChangePasswordUseCase>().call(
      params: ChangePasswordReq(
          oldPassword: oldPassword,
          newPassword: newPassword
      ),
    );

    result.fold(
          (error) => emit(ChangePasswordFailure(error)),
          (_) async {
            sl<PocketBaseClient>().logout();
            emit(ChangePasswordSuccess());
      },
    );
  }
}