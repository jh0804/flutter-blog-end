import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postWriteProvider = NotifierProvider<PostWriteFM, PostWriteModel>(() {
  return PostWriteFM();
});

class PostWriteFM extends Notifier<PostWriteModel> {
  @override
  PostWriteModel build() {
    return PostWriteModel("", "");
  }

  void title(String title) {
    state = state.copyWith(
      title: title,
    );
  }

  void content(String content) {
    state = state.copyWith(
      content: content,
    );
  }
}

class PostWriteModel {
  final String title;
  final String content;

  PostWriteModel(
    this.title,
    this.content,
  );

  PostWriteModel copyWith({
    String? title,
    String? content,
  }) {
    return PostWriteModel(
      title ?? this.title,
      content ?? this.content,
    );
  }

  @override
  String toString() {
    return 'PostWriteModel{title: $title, content: $content}';
  }
}
