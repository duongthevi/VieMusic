import 'package:get_it/get_it.dart';
import '../core/database/pocketbase_client.dart';

void registerCoreDependencies(GetIt sl) {
  sl.registerLazySingleton<PocketBaseClient>(
        () => PocketBaseClient(sl()),
  );
}