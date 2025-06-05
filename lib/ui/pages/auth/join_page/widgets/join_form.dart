import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/ui/pages/auth/join_page/join_fm.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    JoinFM fm = ref.read(joinProvider.notifier);
    JoinModel model = ref.watch(joinProvider);

    print("창고 state : ${model}");

    return Form(
      child: Column(
        children: [
          CustomAuthTextFormField(
            title: "Username",
            errorText: model.usernameError,
            onChanged: (value) {
              fm.username(value);
            },
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            title: "Email",
            errorText: model.emailError,
            onChanged: (value) {
              fm.email(value);
            },
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            title: "Password",
            errorText: model.passwordError,
            obscureText: true,
            onChanged: (value) {
              fm.password(value);
            },
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "회원가입",
            click: () {
              ref.read(sessionProvider.notifier).join(model.username, model.email, model.password);
            },
          ),
          CustomTextButton(
            text: "로그인 페이지로 이동",
            click: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
