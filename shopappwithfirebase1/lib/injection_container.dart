import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'features/posts/data/datasources/local_data_source.dart';
import 'features/posts/data/datasources/remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post%20repositories.dart';
import 'features/posts/domain/usecases/add_post.dart';
import 'features/posts/domain/usecases/delete_post.dart';
import 'features/posts/domain/usecases/get_all_post.dart';
import 'features/posts/domain/usecases/update_post.dart';
import 'features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'features/posts/presentation/bloc/posts/posts_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! features Post

//Bloc

  sl.registerFactory(() => PostsBloc(getAllPosts: sl()));
  sl.registerFactory(
    () => AddDeleteUpdatePostBloc(
      addPost: sl(),
      updatePost: sl(),
      deletePost: sl(),
    ),
  );

// UseCase

  sl.registerLazySingleton(() => GetAllPostUseCase(sl()));
  sl.registerLazySingleton(() => AddPostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));

// Repository

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
        remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );

//DataSource

  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(client: sl()),
  );
sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: sl()),
  );
//! Core

sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External
final sharedPreferences=await SharedPreferences.getInstance();
sl.registerLazySingleton(() => sharedPreferences);
sl.registerLazySingleton(() => http.Client());
sl.registerLazySingleton(() => InternetConnectionChecker());

}
