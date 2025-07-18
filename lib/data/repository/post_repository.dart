import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:logger/logger.dart';

class PostRepository {
  Future<Map<String, dynamic>> getList({int page = 0}) async {
    Response response = await dio.get("/api/post", queryParameters: {"page": page});
    final responseBody = response.data; // = Map<String, dynamic> responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // TODO 1 : getOne(postId) 만들기 + 테스트 코드
  Future<Map<String, dynamic>> getOne(int postId) async {
    Response response = await dio.get("/api/post/${postId}");
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  Future<Map<String, dynamic>> deleteOne(int postId) async {
    Response response = await dio.delete("/api/post/${postId}");
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  Future<Map<String, dynamic>> write(String title, String content) async {
    Response response = await dio.post("/api/post", data: {"title": title, "content": content});
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  Future<Map<String, dynamic>> updateOne(Post post) async {
    Response response = await dio.put("/api/post/${post.id}", data: {"title": post.title, "content": post.content});
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }
}
