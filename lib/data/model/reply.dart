import 'package:flutter_blog/data/model/user.dart';

class Reply {
  int id;
  String comment;
  DateTime createdAt;
  User replyUser;

  Reply({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.replyUser,
  });

  Reply.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        comment = data['comment'],
        createdAt = DateTime.parse(data['createdAt']),
        replyUser = User.fromMap(data['replyUser']);
}
