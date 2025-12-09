import 'package:get_it/get_it.dart';
import '../core/network/api_service.dart';
import '../core/storage/secure_storage_service.dart';
import '../core/theme/theme_service.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/notification/data/repositories/notification_repository_impl.dart';
import '../features/notification/domain/repositories/notification_repository.dart';
import '../features/notification/presentation/bloc/notification_bloc.dart';

/// Service locator instance for dependency injection
/// Use this to access registered dependencies throughout the app
/// Follows Dependency Inversion Principle (SOLID)
final sl = GetIt.instance;

/// Initializes all dependencies for the application
/// This should be called before running the app in main.dart
/// 
/// Registers dependencies in order:
/// 1. External dependencies (API service, secure storage)
/// 2. Repository layer (data layer implementations)
/// 3. BLoC layer (presentation layer)
/// 
/// Follows Clean Architecture principles
Future<void> init() async {
  // External dependencies
  // These are singletons that persist for the app lifetime
  sl.registerLazySingleton<ApiService>(
    () => ApiService(),
  );

  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // Repository layer
  // Repositories implement domain interfaces and handle data operations
  // Follows Interface Segregation Principle (SOLID)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: sl(),
      secureStorage: sl(),
    ),
  );

  // BLoC layer
  // BLoCs are registered as factories to create new instances per widget tree
  // This allows multiple instances if needed (e.g., different screens)
  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl(),
      secureStorage: sl(),
    ),
  );

  // Theme Service - Simple ChangeNotifier (no BLoC needed for simple state)
  // Singleton to maintain theme state across app
  sl.registerLazySingleton(
    () => ThemeService(sl()),
  );

  // Home Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(),
  );

  // Profile Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      secureStorage: sl(),
    ),
  );

  // Notification Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(),
  );

  // Home BLoC - Factory to create new instances
  sl.registerFactory(
    () => HomeBloc(
      homeRepository: sl(),
    ),
  );

  // Profile BLoC - Factory to create new instances
  sl.registerFactory(
    () => ProfileBloc(
      profileRepository: sl(),
    ),
  );

  // Notification BLoC - Factory to create new instances
  sl.registerFactory(
    () => NotificationBloc(
      notificationRepository: sl(),
    ),
  );
}
