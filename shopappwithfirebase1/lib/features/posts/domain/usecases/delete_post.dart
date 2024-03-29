import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/post%20repositories.dart';

class DeletePostUseCase {
  final PostRepository repository;

 DeletePostUseCase(this.repository);
  Future<Either<Failure,Unit>> call(int postId) async{
    return await repository.deletePost(postId);
  }
}