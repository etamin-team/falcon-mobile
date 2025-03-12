import 'package:flutter/material.dart';
import 'package:wm_doctor/core/widgets/custom_text_form_field.dart';

class CustomDropDownCardWidget extends StatelessWidget {
  final TextEditingController textController;
  final String title;
  final String hint;

  final VoidCallback onClick;

  final FormFieldValidator<String?>? validator;

  const CustomDropDownCardWidget(
      {super.key,

      required this.title,
      required this.onClick,
      required this.textController,
      this.validator, required this.hint});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onClick,
      child: AppTextField(

        isEnabled: false,
        textColor: Colors.black,
        controller: textController,
        hintText: hint,
        title: title,
        validator: validator,
        suffixIcon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),


      ),
    );
  }
}
