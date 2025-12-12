import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import '../../repository/auth/auth_repository.dart';
import '../../../service_locator.dart';
import 'change_password_req.dart';

class ChangePasswordUseCase implements UseCase<Either<String, Unit>, ChangePasswordReq> {
  @override
  Future<Either<String, Unit>> call({ChangePasswordReq? params}) async {
    return await sl<AuthRepository>().changePassword(params!);
  }
}