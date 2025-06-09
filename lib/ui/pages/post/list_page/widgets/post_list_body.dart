import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_vm.dart';
import 'package:flutter_blog/ui/pages/post/list_page/widgets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 접근
    PostListModel? model = ref.watch(postListProvider);
    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.separated(
        itemCount: model.posts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailPage()));
            },
            child: PostListItem(model.posts[index]),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    }
  }
}
