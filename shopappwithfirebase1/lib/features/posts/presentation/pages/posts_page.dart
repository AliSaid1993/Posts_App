import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/posts/posts_bloc.dart';
import 'post_add_update_page.dart';
import '../widgets/post_page/message_display_widget.dart';
import '../widgets/post_page/post_list_widget.dart';

import '../../../../core/widgets/loading_widget.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingBtn(context),
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: const Text("Posts"),
      );

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is LoadingPostState) {
            return const LoadingWidget();
          } else if (state is LoadedPostState) {
            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: PostListWidget(posts: state.posts),
            );
          } else if (state is ErrorPostState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<PostsBloc>(context).add((RefreshPostsEvent()));
  }

  Widget _buildFloatingBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                // ignore: prefer_const_constructors
                builder: (_) =>  PostAddUpdatePage(
                  isUpdatePost: false,
                  ),
                  ),
                  );
      },
      child: const Icon(Icons.add),
    );
  }
}
