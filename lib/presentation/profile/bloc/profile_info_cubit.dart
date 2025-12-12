import 'package:ct312h_project/presentation/profile/bloc/profile_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth/get_user.dart';
import '../../../service_locator.dart';


class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  ProfileInfoCubit() : super (ProfileInfoInitial());

  Future<void> getUser() async {
    emit(ProfileInfoLoading());
    var user = await sl<GetUserUseCase>().call();
    user.fold(
            (failureMessage){
          emit(
              ProfileInfoFailure(message: failureMessage)
          );
        },
            (userEntity) {
          emit(
              ProfileInfoLoaded(userEntity: userEntity)
          );
        }
    );
  }
}