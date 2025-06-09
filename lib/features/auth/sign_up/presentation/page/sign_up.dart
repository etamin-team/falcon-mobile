import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wm_doctor/core/constant/diments.dart';
import 'package:wm_doctor/core/styles/app_colors.dart';
import 'package:wm_doctor/core/widgets/custom_text_form_field.dart';
import 'package:wm_doctor/core/widgets/universal_button.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/page/sign_up_data.dart';
import 'package:wm_doctor/gen/assets.gen.dart';

import '../../../../../core/utils/text_mask.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../cubit/sign_up_cubit.dart';
import '../widgets/language.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    numberController.text="";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEBF2FA), // Yuqori qism uchun rang
            Color(0xFFD7E9F6), // Yuqori qism uchun rang
            Color(0xFF98B0F9), // Pastki qism uchun rang
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: CupertinoColors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // title: Image.asset(Assets.images.logo.path,height: 40,),
          toolbarHeight: Dimens.space100,
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          actions: [
            GestureDetector(
              onTap: () {
                showLanguageChoice(ctx: context);
              },
              child: Container(
                decoration:
                BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                padding: EdgeInsets.all(Dimens.space16),
                margin: EdgeInsets.only(right: Dimens.space20),
                child: SvgPicture.asset(Assets.icons.global),
              ),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(40)),
            padding: EdgeInsets.all(Dimens.space20),
            margin: EdgeInsets.symmetric(
                horizontal: Dimens.space20, vertical: Dimens.space30),
            child: Column(
              spacing: Dimens.space10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.texts_sign_up.tr(),
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w400, fontSize: 32),
                ),
                SizedBox(),
                Form(
                  key: formKey,
                  child: AppTextField(
                      onChanged: (value) {
                        if(value.toString().length==12){
                          context.read<SignUpCubit>().checkNumber(number: "998${value.toString().replaceAll(" ", "").replaceAll("+", "")}");
                        }
                        setState(() {});
                      },
                      validator: (value) {
                        if (value.toString().length < 12) {
                          return       LocaleKeys.sign_up_validate_number.tr();
                        }
                        return null;
                      },
                      prefixIcon: Text("+998 "),
                      keyboardType: TextInputType.phone,
                      formatter: [
                        TextMask(pallet: '## ### ## ##'),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\+?[0-9\s]*$'),
                            replacementString: ""),
                        LengthLimitingTextInputFormatter(12),
                      ],
                      title:       LocaleKeys.sign_up_phone_number.tr(),
                      controller: numberController,
                      hintText: "90 123 45 67"),
                ),
                SizedBox(),
                Row(
                  spacing: Dimens.space10,
                  children: [
                    Expanded(
                      flex: 1,
                      child: UniversalButton.outline(
                        height: Dimens.space60,
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color: Colors.black,
                          size: 25,
                        ),
                        text: "",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          if(state is SignUpCheckNumberLoading){
                            return UniversalButton.filled(
                              enabled: true,
                              height: Dimens.space60,
                              icon: CupertinoActivityIndicator(color: Colors.white,),
                              text: "",
                              textFontWeight: FontWeight.w400,
                              onPressed: () {
                              },
                            );
                          }
                          if(state is SignUpCheckNumberSuccess){
                            if(numberController.text.length!=12){
                              return UniversalButton.filled(
                                enabled: false,
                                height: Dimens.space60,
                                fontSize: 14,
                                text:       LocaleKeys.texts_continue.tr(),
                                textFontWeight: FontWeight.w400,
                                onPressed: () {

                                },
                              );
                            }
                            return UniversalButton.filled(
                              enabled: !state.isExist,
                              height: Dimens.space60,
                              fontSize: 14,
                              text: LocaleKeys.texts_continue.tr(),
                              textFontWeight: FontWeight.w400,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpData(
                                            number: numberController.text
                                                .trim()
                                                .replaceAll(" ", ""),
                                          )));
                                }
                              },
                            );

                          }
                          if(numberController.text.length!=17){
                            return UniversalButton.filled(
                              enabled: false,
                              height: Dimens.space60,
                              fontSize: 14,
                              text: LocaleKeys.texts_continue.tr(),
                              textFontWeight: FontWeight.w400,
                              onPressed: () {

                              },
                            );
                          }
                          return UniversalButton.filled(
                            enabled: false,
                            height: Dimens.space60,
                            fontSize: 14,
                            text: LocaleKeys.texts_continue.tr(),
                            textFontWeight: FontWeight.w400,
                            onPressed: () {

                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
