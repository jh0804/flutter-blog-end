import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_vm.dart';
import 'package:flutter_blog/ui/pages/post/update_page/post_update_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailButtons extends ConsumerWidget {
  Post post;

  PostDetailButtons(this.post);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionModel sessionModel = ref.read(sessionProvider);
    PostDetailVM vm = ref.read(postDetailProvider(post.id).notifier);

    // 창고에 접근해서 isOwner이라는 함수로 처리하는 방법도 있다.
    // SessionGVM sessionGVM = ref.read(sessionProvider.notifier);
    // sessionGVM.isOwner(post.user.id);

    if (sessionModel.user!.id != post.user.id) {
      return SizedBox();
    } else {
      return Row(
        // 내가 쓴 글일 때만 보임 1. isOwner 서버 개발자에게 만들어 달라고 하기 2. sessionGVM의 유저와 PostDetail의 유저 비교
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              vm.deleteOne(post.id);
            },
            icon: const Icon(CupertinoIcons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PostUpdatePage()));
            },
            icon: const Icon(CupertinoIcons.pen),
          ),
        ],
      );
    }
  }
}
