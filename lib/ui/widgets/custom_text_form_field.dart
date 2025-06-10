import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final Function(String)? onChanged; // 매개변수가 있는 함수
  final String initalValue; // 매번 받을 필요X -> 선택적 & 빈 문자열로 초기화

  CustomTextFormField({
    required this.hint,
    this.obscureText = false,
    this.onChanged,
    this.initalValue = "",
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initalValue,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Enter $hint",
        enabledBorder: OutlineInputBorder(
          // 3. 기본 TextFormField 디자인
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          // 4. 손가락 터치시 TextFormField 디자인
          borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: OutlineInputBorder(
          // 5. 에러발생시 TextFormField 디자인
          borderRadius: BorderRadius.circular(20),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // 5. 에러가 발생 후 손가락을 터치했을 때 TextFormField 디자인
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
