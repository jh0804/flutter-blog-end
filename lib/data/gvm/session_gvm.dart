import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/ui/pages/auth/join_page/join_fm.dart';
import 'package:flutter_blog/ui/pages/auth/login_page/login_fm.dart';
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

  Future<void> login(String username, String password) async {
    // 1. 유효성 검사
    Logger().d("username : ${username}, password : ${password}");
    bool isValid = ref.read(loginProvider.notifier).validate();
    if (!isValid) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("유효성 검사 실패")),
      );
      return;
    }

    // 2. 통신
    Map<String, dynamic> body = await UserRepository().login(username, password);
    if (!body["success"]) {
      // = 통신 실패
      // 토스트 띄우기
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text("${body["errorMessage"]}")),
      );
      return;
    }

    // 3. 파싱
    User user = User.fromMap(body["response"]);

    // 4. 토큰 디바이스 저장 -> 앱 껐다가 켜도 자동 로그인 가능
    await secureStorage.write(key: "accessToken", value: user.accessToken);

    // 5. 세션 모델 갱신 (현재 isLogin = false 상태 / fromMap 파싱하는거 만드는게 낫다 아니면 밑의 코드처럼 다 적어야됨)
    state = SessionModel(user: user, isLogin: true);

    // 6. dio의 header에 토큰 세팅 // 매번 안해도 된다. 통신 및 필요할 때마다 dio.post에서 넣어줘야 됨
    dio.options.headers["Authorization"] = user.accessToken;

    // 7. 게시글 목록 페이지 이동 / popAndPushNamed -> 화면 날리고 들어간다.(로그인 안한걸로 되돌아갈거 아니니까/ 안날리면 모든 화면 쌓여있음) / 이런거 gpt한테 물어보기
    Navigator.pushNamed(mContext, "/post/list");
  }

  Future<void> logout() async {
    // 1. 토큰 디바이스 제거

    // 2. 세션 모델 초기화

    // 3. dio 세팅 제거

    // 4. login 페이지 이동
  }
}

/// 3. 창고 데이터 타입
class SessionModel {
  User? user;
  bool? isLogin;

  SessionModel({this.user, this.isLogin = false});

  @override
  String toString() {
    return 'SessionModel{user: $user, isLogin: $isLogin}';
  }

  // 화면 갱신X -> copyWith 안 만듦
}
