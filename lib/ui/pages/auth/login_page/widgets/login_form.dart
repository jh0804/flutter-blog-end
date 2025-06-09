import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/ui/pages/auth/login_page/login_fm.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class LoginForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LoginFM fm = ref.read(loginProvider.notifier);
    LoginModel model = ref.watch(loginProvider); // errorText 때문에 watch -> 아니면 필요X

    // Logger().d(model); // toString이 있으니까 바로 보인다

    return Form(
      child: Column(
        children: [
          CustomAuthTextFormField(
            title: "Username",
            errorText: model.usernameError,
            onChanged: (value) {
              // 변경되는 value 전부 여기 넣어줌
              fm.username(value);
            },
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            title: "Password",
            errorText: model.passwordError,
            obscureText: true,
            onChanged: (value) {
              // 변경되는 value 전부 여기 넣어줌
              fm.password(value);
            },
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "로그인",
            click: () {
              ref.read(sessionProvider.notifier).login(model.username.trim(), model.password.trim()); // 띄어쓰기 같은거 같이 안날아가도록 trim 처리
            },
          ),
          CustomTextButton(
            text: "회원가입 페이지로 이동",
            click: () {
              Navigator.pushNamed(context, "/join");
            },
          ),
        ],
      ),
    );
  }
}
