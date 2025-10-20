import 'package:get_it/get_it.dart';
import '../core/network/api_client.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/counter/presentation/bloc/counter_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => ApiClient());
  
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: sl()),
  );
  
  // Bloc
  sl.registerFactory(
    () => AuthBloc(authRepository: sl()),
  );
  
  sl.registerFactory(
    () => CounterBloc(),
  );
}
