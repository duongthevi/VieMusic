import 'package:dartz/dartz.dart';
import '../../../core/usecase/usecase.dart';
import 'signin_user_req.dart';
import '../../repository/auth/auth_repository.dart';

class SigninUseCase implements UseCase<Either<String, Unit>, SigninUserReq> {
  final AuthRepository _repository;
  SigninUseCase(this._repository);

  @override
  Future<Either<String, Unit>> call({SigninUserReq? params}) async {
    if (params == null) {
      return Left('Information is required!');
    }
    return _repository.signin(params);
  }
}