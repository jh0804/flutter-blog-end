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
    Map<String, dynamic> responseBody = response.data; // = final responseBody = response.data;

    // 3. 헤더에서 토큰 꺼내야 됨 (서버에서 body에 넘겨주면 편하다..)
    String accessToken = "";
    try {
      accessToken = response.headers["Authorization"]![0]; // null 절대 아니야 라고 해두면 catch 탄다. 헤더의 키에 대한 value가 여러개일수도 있으니 0번지로
      responseBody["response"]["accessToken"] = accessToken; // 이렇게 하면 responseBody만 던져주면 된다.
    } catch (e) {}

    Logger().d(responseBody); // Map에 제대로 들어갔는지 검증 가능
    return responseBody;
  }
}
