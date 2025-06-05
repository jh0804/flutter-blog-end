import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/ui/pages/auth/join_page/join_fm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// 1. 창고 관리자
final sessionProvider = NotifierProvider<SessionGVM, SessionModel>(() {
  return SessionGVM();
});

/// 2. 창고 (상태가 변경되어도 화면 갱신 안 함 -> watch 하지마)
class SessionGVM extends Notifier<SessionModel> {
  final mContext = navigatorKey.currentContext!;
  @override
  SessionModel build() {
    return SessionModel(); // isLogin만 false고 나머지는 null
  }

  Future<void> join(String username, String email, String password) async {
    Logger().d("username : ${username}, email : ${email}, password : ${password}");
    bool isValid = ref.read(joinProvider.notifier).validate();
    if (!isValid) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("유효성 검사 실패")),
      );
      return;
    }

    // 나중에는 final로 적으면 끝 지금은 이해를 위해 정확하게 타입을 map으로 작성
    Map<String, dynamic> body = await UserRepository().join(username, email, password); // 나중에 싱글톤으로 만들기 - 매번 객체 생성X
    if (!body["success"]) {
      // = 통신 실패
      // 토스트 띄우기
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("${body["errorMessage"]}")),
      );
      return;
    }

    // 통신 성공하면 로그인 페이지로 이동
    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> login(String username, String password) async {}
  Future<void> logout() async {}
}

/// 3. 창고 데이터 타입
class SessionModel {
  int? id;
  String? userName;
  String? accessToken; // 통신할 때 매번 device에서 꺼내는 것보다 메모리에서 꺼내는 게 낫다. (device는 자동로그인할 때 쓸거임)
  bool? isLogin;

  SessionModel({this.id, this.userName, this.accessToken, this.isLogin = false});

  // 화면 갱신X -> copyWith 안 만듦
}
