part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class LoadingPostState extends PostsState {}

class LoadedPostState extends PostsState {
  final List<Post> posts;

  const LoadedPostState({required this.posts});
  @override
  List<Object> get props => [posts];
}

class ErrorPostState extends PostsState {
  final String message;

  const ErrorPostState({required this.message});
  @override
  List<Object> get props => [message];
}
