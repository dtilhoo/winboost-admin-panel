import 'package:get_it/get_it.dart';
import '../data/repositories/admin_repository.dart';
import '../domain/usecases/admin_usecases.dart';
import '../data/repositories/auth_repository.dart';
import '../features/auth/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Repositories
  getIt.registerLazySingleton(() => AdminRepository());
  getIt.registerLazySingleton(() => AuthRepository());

  // UseCases
  getIt.registerLazySingleton(() => GetDashboardMetricsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRoleApprovalsUseCase(getIt()));
  getIt.registerLazySingleton(() => ManageWalletUseCase(getIt()));
  getIt.registerLazySingleton(() => ManageCategoryUseCase(getIt()));
  getIt.registerLazySingleton(() => ManageMerchantProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => ManagePartnershipsUseCase(getIt()));
  getIt.registerLazySingleton(() => ManageMessagesUseCase(getIt()));
  getIt.registerLazySingleton(() => ManageCountersUseCase(getIt()));
  getIt.registerLazySingleton(() => ManageNotificationsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetLogsUseCase(getIt()));

  // Blocs / Cubits (Global singleton for Auth to listen anywhere)
  getIt.registerLazySingleton(() => AuthCubit(repository: getIt()));

  // New usecases to add later can be registered here
}
