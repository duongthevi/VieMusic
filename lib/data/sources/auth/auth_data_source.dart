import 'package:dartz/dartz.dart';
import '../../../domain/usecases/auth/change_password_req.dart';
import '../../../domain/usecases/auth/create_user_req.dart';
import '../../../domain/usecases/auth/signin_user_req.dart';
import '../../../domain/usecases/auth/update_user_req.dart';
import '../../models/auth/user_model.dart';

abstract class AuthDataSource {
  Future<Either<String, Unit>> signup(CreateUserReq createUserReq);
  Future<Either<String, Unit>> signin(SigninUserReq signinUserReq);
  Future<Either<String, UserModel>> getUser();
  Future<Either<String, Unit>> updateProfile(UpdateUserReq updateUserReq);

  Future<Either<String, List<String>>> getFollowedArtistsIds();
  Future<Either<String, Unit>> addFollowedArtist(String artistId);
  Future<Either<String, Unit>> removeFollowedArtist(String artistId);
  Future<Either<String, Unit>> resetPassword(String email);
  Future<bool> checkEmailExists(String email);
  Future<Either<String, Unit>> changePassword(ChangePasswordReq req);
}