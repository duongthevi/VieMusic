import 'package:get_it/get_it.dart';

import '../data/repository/auth/auth_repository_impl.dart';
import '../data/sources/auth/auth_data_source.dart';
import '../data/sources/auth/auth_pocketbase_data_source.dart';
import '../domain/repository/auth/auth_repository.dart';
import '../domain/usecases/auth/change_password.dart';
import '../domain/usecases/auth/get_user.dart';
import '../domain/usecases/auth/reset_password.dart';
import '../domain/usecases/auth/signin.dart';
import '../domain/usecases/auth/signup.dart';

import '../domain/usecases/auth/update_user.dart';

void registerAuthDependencies(GetIt sl) {
  sl.registerLazySingleton<AuthDataSource>(
          () => AuthPocketBaseDataSource(sl()));

  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(sl(), sl()));

  sl.registerFactory<SignupUseCase>(
          () => SignupUseCase(sl()));

  sl.registerFactory<SigninUseCase>(
          () => SigninUseCase(sl()));

  sl.registerFactory<GetUserUseCase>(
          () => GetUserUseCase());

  sl.registerFactory<UpdateUserUseCase>(
          () => UpdateUserUseCase(sl()));

  sl.registerFactory<ResetPasswordUseCase>(
        () => ResetPasswordUseCase(sl()),
  );

  sl.registerFactory<ChangePasswordUseCase>(
          () => ChangePasswordUseCase()
  );
}