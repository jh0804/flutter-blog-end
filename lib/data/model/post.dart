import 'package:flutter_blog/data/model/user.dart';

class Post {
  int id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  int bookmarkCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.bookmarkCount,
  });

  Post.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        content = data['content'],
        createdAt = DateTime.parse(data['createdAt']),
        updatedAt = DateTime.parse(data['updatedAt']),
        bookmarkCount = data['bookmarkCount'],
        user = User.fromMap(data['user']);
}
