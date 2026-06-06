import 'package:get_it/get_it.dart';
import 'package:laporin/core/network/api_client.dart';
import 'package:laporin/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:laporin/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:laporin/features/auth/domain/repositories/auth_repository.dart';
import 'package:laporin/features/auth/domain/usecases/login_usecase.dart';
import 'package:laporin/features/auth/domain/usecases/register_usecase.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:laporin/features/report/data/repositories/report_repository_impl.dart';
import 'package:laporin/features/report/domain/repositories/report_repository.dart';
import 'package:laporin/features/report/domain/usecases/submit_report.dart';
import 'package:laporin/features/report/domain/usecases/get_reports.dart';
import 'package:laporin/features/report/presentation/bloc/report_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), registerUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => MockAuthRemoteDataSource(), // Using Mock for now to fix connection error
    // To use real API, replace with: AuthRemoteDataSourceImpl(client: sl()),
  );

  // Features - Report
  // Bloc
  sl.registerFactory(() => ReportBloc(submitReport: sl(), getReports: sl()));

  // Use cases
  sl.registerLazySingleton(() => SubmitReport(sl()));
  sl.registerLazySingleton(() => GetReports(sl()));


  // Repository
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient());
}
