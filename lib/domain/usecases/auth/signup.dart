import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import 'create_user_req.dart';
import '../../repository/auth/auth_repository.dart';

class SignupUseCase implements UseCase<Either<String, Unit>, CreateUserReq> {
  final AuthRepository _repository;
  SignupUseCase(this._repository);

  @override
  Future<Either<String, Unit>> call({CreateUserReq? params}) async {
    if (params == null) {
      return Left('Information is required!');
    }
    return _repository.signup(params);
  }
}