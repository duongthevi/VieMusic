import 'dart:io';

import 'package:equatable/equatable.dart';

class UpdateUserReq extends Equatable {
  final String newFullName;
  final File? newAvatarFile;

  const UpdateUserReq({
    required this.newFullName,
    this.newAvatarFile,
  });

  UpdateUserReq copyWith({
    String? newFullName,
    File? newAvatarFile,
  }) {
    return UpdateUserReq(
      newFullName: newFullName ?? this.newFullName,
      newAvatarFile: newAvatarFile ?? this.newAvatarFile,
    );
  }

  @override
  List<Object?> get props => [newFullName, newAvatarFile];
}