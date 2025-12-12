import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final String message;

  const EditProfileSuccess({this.message = 'Cập nhật hồ sơ thành công!'});

  @override
  List<Object?> get props => [message];
}

class EditProfileFailure extends EditProfileState {
  final String message;

  const EditProfileFailure({required this.message});

  @override
  List<Object?> get props => [message];
}