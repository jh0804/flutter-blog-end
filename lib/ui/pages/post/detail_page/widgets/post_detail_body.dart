import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_vm.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_buttons.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_content.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_profile.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailBody extends ConsumerWidget {
  int postId;

  PostDetailBody(this.postId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostDetailModel? model = ref.watch(postDetailProvider(postId)); // 통신은 무조건 watch : 보고 있다가 변경되어야 하니까

    // TODO 4 : model 데이터 렌더링하기
    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            PostDetailTitle("${model.post.title}"),
            const SizedBox(height: largeGap),
            PostDetailProfile(model.post), // user 넘기고 email은 생략 (실제로는 서버한테 email 추가해달라고 이야기)
            PostDetailButtons(model.post), // post 넘겨서 안에서 if 처리 OR 여기서 if 처리 (User가 아니라 Post를 넘겨야 하는 이유 = id로 삭제하기 위해
            const Divider(),
            const SizedBox(height: largeGap),
            PostDetailContent("${model.post.content}"),
          ],
        ),
      );
    }
  }
}
