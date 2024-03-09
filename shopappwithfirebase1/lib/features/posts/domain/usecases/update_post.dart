import 'package:dartz/dartz.dart';
import '../repositories/post%20repositories.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post.dart';

class UpdatePostUseCase {
  final PostRepository repository;

  UpdatePostUseCase(this.repository);
  Future<Either<Failure,Unit>> call(Post post) async{
    return await repository.updatePost(post);
  }
}