import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 1. 창고 관리자
final postListProvider = AutoDisposeNotifierProvider<PostListVM, PostListModel?>(() {
  return PostListVM();
});

/// 2. 창고 (상태가 변경되어도 화면 갱신 안 함 -> watch 하지마)
class PostListVM extends AutoDisposeNotifier<PostListModel?> {
  final mContext = navigatorKey.currentContext!;
  final refreshCtrl = RefreshController(); // state는 아니고 창고가 가지고 있는 부산물같은 것

  @override
  PostListModel? build() {
    init();

    ref.onDispose(() {
      Logger().d("PostListVM 파괴됨");
    });

    return null;
  }

  Future<void> init({int page = 0}) async {
    Map<String, dynamic> body = await PostRepository().getList(page: page);
    if (!body["success"]) {
      // = 통신 실패
      // 토스트 띄우기
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("init 실패 : ${body["errorMessage"]}")),
      );
      return;
    }
    state = PostListModel.fromMap(body["response"]);

    // init이 종료될 때 실행되어야 하는 마지막 트랜잭션
    refreshCtrl.refreshCompleted();
  }

  void notifyDeleteOne(int postId) {
    PostListModel model = state!;

    model.posts = model.posts.where((p) => p.id != postId).toList();

    state = state!.copyWith(posts: model.posts);
  }

  // 트랜잭션(일의 최소 단위) 관리
  Future<void> write(String title, String content) async {
    Logger().d("글쓰기 버튼 클릭 : $title, $content");
    // 1. repository의 함수 호출
    Map<String, dynamic> body = await PostRepository().write(title, content);

    // 2. 성공 여부 확인 - 함수로 만들어서 호출하면 편하다
    if (!body["success"]) {
      // = 통신 실패
      // 토스트 띄우기
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("게시글 쓰기 실패 : ${body["errorMessage"]}")),
      );
      return;
    }

    // 3. 파싱
    Post post = Post.fromMap(body["response"]);

    // 4. List 상태 갱신
    //state!.posts = [post, ...state!.posts]; // 전개 연산자 (... = 흩뿌리다) // posts의 앞에 post 넣은 것 // 이렇게 하면 기존의 상태를 변경하는 것
    List<Post> nextPosts = [post, ...state!.posts];
    state = state!.copyWith(posts: nextPosts);

    // 5. 글쓰기 화면 pop
    Navigator.pop(mContext);
  }

  void notifyUpdate(Post post) {
    // map으로 for문을 돌려서 update된 게시글 찾아내기
    List<Post> nextPosts = state!.posts.map((p) {
      if (p.id == post.id) {
        return post;
      } else {
        return p;
      }
    }).toList();

    state = state!.copyWith(posts: nextPosts);
    // = init();
  }

  Future<void> nextList() async {
    PostListModel prevModel = state!;

    if (prevModel.isLast) {
      await Future.delayed(Duration(milliseconds: 500)); // 0.5초간 로딩되는 걸 봐야 오류가 아닌걸 느낄 수 있음
      refreshCtrl.loadComplete();
      return;
    }

    Map<String, dynamic> body = await PostRepository().getList(page: prevModel.pageNumber + 1);
    if (!body["success"]) {
      // = 통신 실패
      // 토스트 띄우기
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("게시글 load 실패 : ${body["errorMessage"]}")),
      );
      refreshCtrl.loadComplete();
      return;
    }

    PostListModel nextModel = PostListModel.fromMap(body["response"]);
    // nextModel의 isFirst totalPage를 사용해야함.
    // nextModel의 컬렉션 + 이전 모델의 컬렉션 = 전개 연산자로 해결
    state = nextModel.copyWith(posts: [...prevModel.posts, ...nextModel.posts]);
  }
}

/// 3. 창고 데이터 타입
class PostListModel {
  bool isFirst;
  bool isLast;
  int pageNumber;
  int size;
  int totalPage;
  List<Post> posts;

  PostListModel(this.isFirst, this.isLast, this.pageNumber, this.size, this.totalPage, this.posts);

  PostListModel.fromMap(Map<String, dynamic> data)
      : isFirst = data['isFirst'],
        isLast = data['isLast'],
        pageNumber = data['pageNumber'],
        size = data['size'],
        totalPage = data['totalPage'],
        posts = (data['posts'] as List).map((e) => Post.fromMap(e)).toList();

  // 화면 갱신할거니까 copyWith 필요O
  PostListModel copyWith({
    bool? isFirst,
    bool? isLast,
    int? pageNumber,
    int? size,
    int? totalPage,
    List<Post>? posts,
  }) {
    return PostListModel(
      isFirst ?? this.isFirst,
      isLast ?? this.isLast,
      pageNumber ?? this.pageNumber,
      size ?? this.size,
      totalPage ?? this.totalPage,
      posts ?? this.posts,
    );
  }

  // Logger를 위한 toString
  @override
  String toString() {
    return 'PageListModel{isFirst: $isFirst, isLast: $isLast, pageNumber: $pageNumber, size: $size, totalPage: $totalPage, posts: $posts}';
  }
}
