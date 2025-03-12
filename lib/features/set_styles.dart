import 'package:flutter/material.dart';
import 'package:wm_doctor/core/constant/diments.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/widgets/custom_text_form_field.dart';
import 'package:wm_doctor/core/widgets/universal_button.dart';

class SetStyles extends StatefulWidget {
  const SetStyles({super.key});

  @override
  State<SetStyles> createState() => _SetStylesState();
}

class _SetStylesState extends State<SetStyles> {
  final controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: Dimens.space20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppTextField(controller: controller, hintText: "Test hint"),
          UniversalButton.filled(text: "Continiue", onPressed: () {

          },), UniversalButton.outline(borderSide: 2,text: "Continiue", onPressed: () {

          },),
        ],
      ).paddingSymmetric(horizontal: Dimens.space30),
    );
  }
}
