import 'package:http/http.dart' as http;
import 'index.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Reels
  // BLoC
  sl.registerFactory(() => ReelsBloc(getReels: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetReels(repository: sl()));

  // Repository
  sl.registerLazySingleton<ReelsRepository>(
    () => ReelsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      // networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ReelsRemoteDataSource>(
    () => ReelsRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ReelsLocalDataSource>(
    () => ReelsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
