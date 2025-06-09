import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postDetailProvider = NotifierProvider.family<PostDetailVM, PostDetailModel?, int>(() {
  return PostDetailVM();
});

// TODO 3 : init 완성하기 (state 갱신)
class PostDetailVM extends FamilyNotifier<PostDetailModel?, int> {
  final mContext = navigatorKey.currentContext!;

  @override
  PostDetailModel? build(int postId) {
    init(postId);
    return null;
  }

  Future<void> init(int postId) async {
    Map<String, dynamic> body = await PostRepository().getOne(postId);
    if (!body["success"]) {
      // = 통신 실패
      // 토스트 띄우기
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("게시글 상세보기 실패 : ${body["errorMessage"]}")),
      );
      return;
    }
    state = PostDetailModel.fromMap(body["response"]);
  }
}

// TODO 2 : replies 빼고 상태 관리하기
class PostDetailModel {
  Post post;

  PostDetailModel(this.post);

  PostDetailModel.fromMap(Map<String, dynamic> data) : post = Post.fromMap(data);

  PostDetailModel copyWith({
    Post? post,
  }) {
    return PostDetailModel(post ?? this.post);
  }

  @override
  String toString() {
    return 'PostDetailModel(post: $post)';
  }
}
