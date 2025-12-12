import 'package:ct312h_project/core/helpers/error_handler.dart';
import 'package:ct312h_project/core/database/pocketbase_client.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/entities/auth/user_entity.dart';
import '../../../domain/repository/auth/auth_repository.dart';
import '../../../domain/usecases/auth/change_password_req.dart';
import '../../../domain/usecases/auth/create_user_req.dart';
import '../../../domain/usecases/auth/signin_user_req.dart';
import '../../../domain/usecases/auth/update_user_req.dart';
import '../../models/auth/user_model.dart';
import '../../sources/auth/auth_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource authDataSource;
  final PocketBaseClient client;

  AuthRepositoryImpl(this.authDataSource, this.client);

  @override
  Future<Either<String, Unit>> signup(CreateUserReq createUserReq) async {
    final result = await authDataSource.signup(createUserReq);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<Either<String, Unit>> signin(SigninUserReq signinUserReq) async {
    final result = await authDataSource.signin(signinUserReq);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    final result = await authDataSource.getUser();
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (userModel) => Right(userModel.toEntity(client: client)),
    );
  }

  @override
  Future<Either<String, Unit>> updateProfile(UpdateUserReq updateUserReq) async {
    final result = await authDataSource.updateProfile(updateUserReq);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<Either<String, Unit>> resetPassword(String email) async {
    final result = await authDataSource.resetPassword(email);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    return await authDataSource.checkEmailExists(email);
  }

  @override
  Future<Either<String, Unit>> changePassword(ChangePasswordReq req) async {
    final result = await authDataSource.changePassword(req);
    return result.fold(
          (error) => Left(ErrorHandler.mapError(error)),
          (success) => Right(success),
    );
  }
}