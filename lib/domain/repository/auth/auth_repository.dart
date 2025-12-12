import 'package:dartz/dartz.dart';

import '../../../domain/entities/auth/user_entity.dart';
import '../../usecases/auth/change_password_req.dart';
import '../../usecases/auth/create_user_req.dart';
import '../../usecases/auth/signin_user_req.dart';
import '../../usecases/auth/update_user_req.dart';

abstract class AuthRepository {

  Future<Either<String, Unit>> signin(SigninUserReq signinUserReq);
  Future<Either<String, Unit>> signup(CreateUserReq createUserReq);
  Future<Either<String, UserEntity>> getUser();
  Future<Either<String, Unit>> updateProfile(UpdateUserReq updateUserReq);
  Future<Either<String, Unit>> resetPassword(String email);
  Future<bool> checkEmailExists(String email);
  Future<Either<String, Unit>> changePassword(ChangePasswordReq req);
}