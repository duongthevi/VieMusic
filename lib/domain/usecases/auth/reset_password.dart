import 'package:dartz/dartz.dart';
import '../../repository/auth/auth_repository.dart';
import '../../../core/usecase/usecase.dart'; // Đường dẫn tới file UseCase gốc của bạn

class ResetPasswordUseCase implements UseCase<Either<String, Unit>, String> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<String, Unit>> call({String? params}) async {
    final email = params!;

    final isExists = await repository.checkEmailExists(email);

    if (!isExists) {
      return const Left('This email is not logged into the account.');
    }

    return await repository.resetPassword(email);
  }
}