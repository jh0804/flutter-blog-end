import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:logger/logger.dart';

class UserRepository {
  Future<Map<String, dynamic>> join(String username, String email, String password) async {
    final requestBody = {
      "username": username,
      "email": email,
      "password": password,
    };

    Response response = await dio.post("/join", data: requestBody);
    final responseBody = response.data; // = Map<String, dynamic> responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    // 1. Map 변환
    final requestBody = {
      "username": username,
      "password": password,
    };

    // 2. 통신
    Response response = await dio.post("/login", data: requestBody);
    Map<String, dynamic> responseBody = response.data;

    return responseBody;
  }

  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    Response response = await dio.post(
      "/auto/login",
      options: Options(
        headers: {"Authorization": accessToken},
      ),
    ); // 아직 토큰 검증 안됐으므로 dio에 세팅X
    Map<String, dynamic> responseBody = response.data; // response.data = body, response= body & header
    return responseBody;
  }
}
