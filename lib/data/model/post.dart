import 'package:flutter_blog/data/model/user.dart';

class Post {
  int id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  int bookmarkCount; // PostListPage 만들면서 추가 됨
  bool? isBookmark; // PostDetail에서는 무조건 존재하지만 다른 곳에서는 null일 수도 있다.

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.bookmarkCount,
    this.isBookmark,
  });

  Post.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        content = data['content'],
        createdAt = DateTime.parse(data['createdAt']),
        updatedAt = DateTime.parse(data['updatedAt']),
        bookmarkCount = data['bookmarkCount'],
        isBookmark = data['isBookmark'],
        user = User.fromMap(data['user']);
}
