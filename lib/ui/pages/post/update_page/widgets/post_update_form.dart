import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';

class PostUpdateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: [
          CustomTextFormField(
            hint: "Title",
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            hint: "Content",
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글 수정하기",
            click: () {},
          ),
        ],
      ),
    );
  }
}
