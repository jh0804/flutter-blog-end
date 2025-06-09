import 'package:flutter/material.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_body.dart';
import 'package:flutter_blog/ui/widgets/custom_navigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scaffoldKey = GlobalKey<ScaffoldState>(); // 나중에는 누구의 scaffoldkey인지 명확하게 이름을 정하자

class PostListPage extends ConsumerWidget {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  PostListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionModel model = ref.read(sessionProvider);

    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigation(scaffoldKey),
      appBar: AppBar(
        title: Text("Blog ${model.isLogin} ${model.user!.username}"), // 로그인했으니까 절대 null일 수 없는걸 개발자가 안다 = ! 붙여주기
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {},
        child: PostListBody(),
      ),
    );
  }
}
