import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:ct312h_project/core/configs/constants/pocketbase_constants.dart';
import 'package:dartz/dartz.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../../domain/usecases/auth/change_password_req.dart';
import '../../../domain/usecases/auth/update_user_req.dart';
import '../../models/auth/user_model.dart';
import '../../../domain/usecases/auth/create_user_req.dart';
import '../../../domain/usecases/auth/signin_user_req.dart';

import '../base_data_source.dart';
import 'auth_data_source.dart';

class AuthPocketBaseDataSource extends BasePocketBaseDataSource
    implements AuthDataSource {
  AuthPocketBaseDataSource(super._client);

  String? get _currentUserId => pb.authStore.isValid ? pb.authStore.model.id : null;

  @override
  Future<Either<String, Unit>> signup(CreateUserReq createUserReq) async {
    final createResult = await tryCatchWrapper<void>(
          () => pb.collection(PbConstants.usersCollection).create(
        body: createUserReq.toPocketBaseBody(),
      ),
    );
    return createResult.fold(
          (error) => Left(error),
          (_) => signin(
        SigninUserReq(
          email: createUserReq.email,
          password: createUserReq.password,
        ),
      ),
    );
  }

  @override
  Future<Either<String, Unit>> signin(SigninUserReq signinUserReq) async {
    final authResult = await tryCatchWrapper<void>(
          () => pb.collection(PbConstants.usersCollection).authWithPassword(
        signinUserReq.email,
        signinUserReq.password,
      ),
    );
    return authResult.map((_) => unit);
  }

  @override
  Future<Either<String, UserModel>> getUser() async {
    if (!pb.authStore.isValid) {
      return const Left('User is not authenticated');
    }
    final String userId = pb.authStore.model.id;

    final fetchResult = await tryCatchWrapper<UserModel>(
          () async {
        final record = await pb.collection(PbConstants.usersCollection).getOne(userId);
        return UserModel.fromJson(record.toJson());
      },
    );

    return fetchResult;
  }

  @override
  Future<Either<String, Unit>> updateProfile(UpdateUserReq updateUserReq) async {
    final String currentUserId = pb.authStore.model.id;

    if (currentUserId.isEmpty) {
      return const Left('Người dùng chưa đăng nhập hoặc ID không hợp lệ.');
    }

    final updateResult = await tryCatchWrapper<void>(
          () async {
        final Map<String, dynamic> data = {
          'name': updateUserReq.newFullName,
        };

        final List<http.MultipartFile> files = [];

        if (updateUserReq.newAvatarFile != null) {
          files.add(
              await http.MultipartFile.fromPath(
                'avatar',
                updateUserReq.newAvatarFile!.path,
              )
          );
        }

        await pb.collection(PbConstants.usersCollection).update(
          currentUserId,
          body: data,
          files: files,
        );
      },
    );

    return updateResult.fold(
          (error) => Left(error),
          (_) => const Right(unit),
    );
  }

  @override
  Future<Either<String, List<String>>> getFollowedArtistsIds() async {
    final userId = _currentUserId;
    if (userId == null) {
      return const Left('Người dùng chưa đăng nhập.');
    }

    final fetchResult = await tryCatchWrapper<List<String>>(
          () async {
        final record = await pb.collection(PbConstants.usersCollection).getOne(
          userId,
          query: {'fields': 'followed_artists'},
        );
        final List<dynamic> ids = record.data['followed_artists'] as List<dynamic>? ?? [];
        return ids.map((e) => e.toString()).toList();
      },
    );
    return fetchResult;
  }

  @override
  Future<Either<String, Unit>> addFollowedArtist(String artistId) async {
    final userId = _currentUserId;
    if (userId == null) {
      return const Left('Người dùng chưa đăng nhập.');
    }

    final currentListResult = await getFollowedArtistsIds();
    return currentListResult.fold(
          (error) => Left(error),
          (currentIds) async {
        if (currentIds.contains(artistId)) {
          return const Right(unit);
        }

        final updatedIds = [...currentIds, artistId];

        return _updateFollowedArtists(userId, updatedIds);
      },
    );
  }

  @override
  Future<Either<String, Unit>> removeFollowedArtist(String artistId) async {
    final userId = _currentUserId;
    if (userId == null) {
      return const Left('Người dùng chưa đăng nhập.');
    }

    final currentListResult = await getFollowedArtistsIds();
    return currentListResult.fold(
          (error) => Left(error),
          (currentIds) async {
        if (!currentIds.contains(artistId)) {
          return const Right(unit);
        }

        final updatedIds = currentIds.where((id) => id != artistId).toList();

        return _updateFollowedArtists(userId, updatedIds);
      },
    );
  }

  Future<Either<String, Unit>> _updateFollowedArtists(
      String userId, List<String> updatedIds) async {
    final updateResult = await tryCatchWrapper<void>(
          () async {
        await pb.collection(PbConstants.usersCollection).update(
          userId,
          body: {'followed_artists': updatedIds},
        );
        await pb.collection(PbConstants.usersCollection).authRefresh();
      },
    );
    return updateResult.map((_) => unit);
  }

  @override
  Future<Either<String, Unit>> resetPassword(String email) async {
    final result = await tryCatchWrapper<void>(
          () => pb.collection(PbConstants.usersCollection).requestPasswordReset(email),
    );
    return result.map((_) => unit);
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      final result = await pb.collection(PbConstants.usersCollection).getList(
        filter: 'email = "$email"',
        perPage: 1,
      );

      return result.items.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<String, Unit>> changePassword(ChangePasswordReq req) async {
    final userId = pb.authStore.model.id;
    return await tryCatchWrapper<Unit>(() async {
      await pb.collection(PbConstants.usersCollection).update(
        userId,
        body: {
          'oldPassword': req.oldPassword,
          'password': req.newPassword,
          'passwordConfirm': req.newPassword,
        },
      );
      return unit;
    });
  }
}