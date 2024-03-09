// ignore: file_names
// ignore: file_names
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure,List<Post>>> getAllPost();
  Future<Either<Failure, Unit>> deletePost(int id);
  Future<Either<Failure, Unit>> updatePost(Post post);
  Future<Either<Failure, Unit>> addPost(Post post);
}
