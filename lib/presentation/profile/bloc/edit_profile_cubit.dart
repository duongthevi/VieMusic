import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/repository/auth/auth_repository.dart';
import '../../../domain/usecases/auth/update_user_req.dart';
import '../bloc/edit_profile_state.dart';
import 'profile_info_cubit.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final AuthRepository _authRepository;
  final ProfileInfoCubit _profileInfoCubit;

  EditProfileCubit(this._authRepository, this._profileInfoCubit)
      : super(EditProfileInitial());


  Future<File?> pickNewAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<void> updateProfile({
    required String newFullName,
    File? newAvatarFile,
  }) async {
    emit(EditProfileLoading());
    try {
      final req = UpdateUserReq(
        newFullName: newFullName,
        newAvatarFile: newAvatarFile,
      );

      final result = await _authRepository.updateProfile(req);

      result.fold(
            (failure) {
          emit(EditProfileFailure(
              message: 'Cập nhật thất bại: $failure'));
        },
            (userEntity) {
          _profileInfoCubit.getUser();

          emit(const EditProfileSuccess(
              message: 'Cập nhật hồ sơ thành công!'));
        },
      );
    } catch (e) {
      emit(EditProfileFailure(
          message: 'Lỗi không xác định khi cập nhật: $e'));
    }
  }
}