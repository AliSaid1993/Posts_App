import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failure.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/usecases/get_all_post.dart';
import 'package:dartz/dartz.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostUseCase getAllPosts;
  PostsBloc({required this.getAllPosts}) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostState());
        final failureOrposts = await getAllPosts();
               emit(_mapFailureOrPostToState(failureOrposts));

      } else if (event is RefreshPostsEvent) {
         emit(LoadingPostState());
        final failureOrposts = await getAllPosts();
        emit(_mapFailureOrPostToState(failureOrposts));
      }
    });
  }
PostsState _mapFailureOrPostToState ( Either<Failure,List<Post>> either){
  return either.fold(
    (failure) =>  ErrorPostState(message: _mapFailureToMessage(failure)),
   (posts) =>  LoadedPostState(posts: posts)
    );
}

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;

      default:
        return " UnExpected Error , please try again later.";
    }
  }
}
