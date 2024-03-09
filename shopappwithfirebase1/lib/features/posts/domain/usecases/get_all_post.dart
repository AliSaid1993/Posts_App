import 'package:dartz/dartz.dart';
import '../repositories/post%20repositories.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post.dart';

class GetAllPostUseCase {
  final PostRepository repository;

  GetAllPostUseCase(this.repository);
  Future<Either<Failure,List<Post>>> call() async{
    return await repository.getAllPost();
  }
}