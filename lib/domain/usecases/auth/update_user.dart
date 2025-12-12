import 'package:dartz/dartz.dart';

import '../../../domain/repository/auth/auth_repository.dart';
import 'update_user_req.dart';

class UpdateUserUseCase {
  final AuthRepository _authRepository;

  UpdateUserUseCase(this._authRepository);

  Future<Either<String, Unit>> call(UpdateUserReq req) {
    return _authRepository.updateProfile(req);
  }
}