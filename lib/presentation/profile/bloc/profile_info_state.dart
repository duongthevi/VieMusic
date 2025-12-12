import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth/user_entity.dart';

abstract class ProfileInfoState extends Equatable {
  const ProfileInfoState();

  @override
  List<Object> get props => [];
}

class ProfileInfoInitial extends ProfileInfoState {}

class ProfileInfoLoading extends ProfileInfoState {}

class ProfileInfoLoaded extends ProfileInfoState {
  final UserEntity userEntity;
  const ProfileInfoLoaded({required this.userEntity});

  @override
  List<Object> get props => [userEntity];
}

class ProfileInfoFailure extends ProfileInfoState {
  final String message;
  const ProfileInfoFailure({required this.message});

  @override
  List<Object> get props => [message];
}