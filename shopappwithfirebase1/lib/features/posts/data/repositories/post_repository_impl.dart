import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../models/post_model.dart';
import '../../domain/entities/post.dart';
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/post%20repositories.dart';

import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';

//typedef Future<Unit> DeleteOrUpdateOrAddPost ();

class PostRepositoryImpl extends PostRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getAllPost() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteposts = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(remoteposts);
        return Right(remoteposts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async{
    final PostModel postModel =
        PostModel( title: post.title, body: post.body);
   return await _getMessage(() {
    return remoteDataSource.addPost(postModel);
   }
   
   );
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async{
return await _getMessage(() {
    return remoteDataSource.deletePost(id);
   }
   
   ); 
    }
    
     

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async{
 final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);
   return await _getMessage(() {
    return remoteDataSource.updatePost(postModel);
   }
   
   );
    }

Future <Either<Failure,Unit>> _getMessage(Future<Unit> Function() deleteOrupdateOraddPost) async{
 if(await networkInfo.isConnected){
      try{
         await deleteOrupdateOraddPost();
         return const Right(unit);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      return Left(OfflineFailure());
    }  
    }

}
