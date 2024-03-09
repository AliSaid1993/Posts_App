import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';

abstract class RemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> deletePost(int postId);
  Future<Unit> addPost(PostModel postModel);
  Future<Unit> updatePost(PostModel postModel);
}

// ignore: constant_identifier_names
const BASE_URL = "https://jsonplaceholder.typicode.com";

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> getAllPosts() async {
    // ignore: non_constant_identifier_names
    final Response = await client.get(Uri.parse("$BASE_URL/posts/"),
        headers: {"Content_Type": "Application/json"});
    if (Response.statusCode == 200) {
      final List decodedJson = json.decode(Response.body) as List;
      final List<PostModel> postModels = decodedJson
          .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();
      return postModels;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addPost(PostModel postModel) async {
    final body = {
      "title": postModel.title,
      "body": postModel.body,
    };
    // ignore: non_constant_identifier_names
    final Response =
        await client.post(Uri.parse("$BASE_URL/posts/"), body: body);
    if (Response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    // ignore: non_constant_identifier_names
    final Response = await client.delete(
        Uri.parse("$BASE_URL/posts/${postId.toString()}"),
        headers: {"Content_Type": "Application/json"});
        if(Response.statusCode==200){
            return Future.value(unit);
        }else{
          throw ServerException();
        }
  }

  @override
  Future<Unit> updatePost(PostModel postModel) async{
    final postId=postModel.id.toString();
    final body={
      "title":postModel.title,
      "body":postModel.body,
    };
    // ignore: non_constant_identifier_names
    final Response=await client.patch(Uri.parse("$BASE_URL/posts/$postId"),body: body);

    if(Response.statusCode==200){
      return Future.value(unit);
    }else{
      throw ServerException();
    }
  }
}
