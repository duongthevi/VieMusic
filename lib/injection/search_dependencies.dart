import 'package:get_it/get_it.dart';

import 'package:ct312h_project/data/sources/search/search_data_source.dart';
import 'package:ct312h_project/data/sources/search/search_pocketbase_data_source.dart';
import 'package:ct312h_project/data/repository/search/search_repository_impl.dart';
import 'package:ct312h_project/domain/repository/search/search_repository.dart';
import 'package:ct312h_project/domain/usecases/search/search_usecase.dart';
import 'package:ct312h_project/presentation/search/bloc/search_cubit.dart';

void registerSearchDependencies(GetIt sl) {

  sl.registerLazySingleton<SearchDataSource>(
        () => SearchPocketBaseDataSource(sl()),
  );

  sl.registerLazySingleton<SearchRepository>(
        () => SearchRepositoryImpl(
      searchDataSource: sl(),
      client: sl(),
    ),
  );

  sl.registerFactory<SearchUseCase>(
        () => SearchUseCase(repository: sl()),
  );

  sl.registerFactory<SearchCubit>(
        () => SearchCubit(),
  );
}