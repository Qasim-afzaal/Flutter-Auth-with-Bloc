import '../core/network/api_client.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

/// Service locator instance for dependency injection
/// Use this to access registered dependencies throughout the app
final sl = GetIt.instance;

/// Initializes all dependencies for the application
/// This should be called before running the app in main.dart
/// 
/// Registers:
/// - External dependencies (API clients, etc.)
/// - Repositories (data layer)
/// - BLoCs (presentation layer)
Future<void> init() async {
  // External dependencies
  // These are singletons that persist for the app lifetime
  sl.registerLazySingleton(() => ApiClient());
  
  // Repository layer
  // Repositories implement domain interfaces and handle data operations
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: sl()),
  );
  
  // BLoC layer
  // BLoCs are registered as factories to create new instances per widget tree
  sl.registerFactory(
    () => AuthBloc(authRepository: sl()),
  );
}
