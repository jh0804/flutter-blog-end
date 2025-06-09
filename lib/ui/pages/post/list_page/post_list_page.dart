import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/list_page/widgets/post_list_body.dart';
import 'package:flutter_blog/ui/widgets/custom_navigator.dart';

final scaffoldKey = GlobalKey<ScaffoldState>(); // 나중에는 누구의 scaffoldkey인지 명확하게 이름을 정하자

class PostListPage extends StatelessWidget {
  PostListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigation(scaffoldKey),
      appBar: AppBar(
        title: Text("Blog"),
      ),
      body: PostListBody(),
    );
  }
}
