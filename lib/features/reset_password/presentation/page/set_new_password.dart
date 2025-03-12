import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/features/reset_password/presentation/cubit/reset_password_cubit.dart';

import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';

class SetNewPassword extends StatefulWidget {
  final String oldPassword;

  const SetNewPassword({super.key, required this.oldPassword});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();

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
        backgroundColor: Colors.transparent,
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          // title: Image.asset(
          //   Assets.images.logo.path,
          //   height: 40,
          // ),
          toolbarHeight: Dimens.space100,
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //       showLanguageChoice(ctx: context);
          //     },
          //     child: Container(
          //       decoration:
          //       BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
          //       padding: EdgeInsets.all(Dimens.space16),
          //       margin: EdgeInsets.only(right: Dimens.space20),
          //       child: SvgPicture.asset(Assets.icons.global),
          //     ),
          //   )
          // ],
        ),
        body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is UpdatePasswordSuccess) {
              toastification.show(
                style: ToastificationStyle.flat,
                context: context,
                type: ToastificationType.success,
                alignment: Alignment.topCenter,
                title: Text(LocaleKeys.reset_password_password_updated.tr()),
                autoCloseDuration: const Duration(seconds: 3),
                showProgressBar: false,
                primaryColor: Colors.white,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              );
              Navigator.pop(context);
              Navigator.pop(context);
            }
            if (state is UpdatePasswordError) {
              toastification.show(
                style: ToastificationStyle.flat,
                context: context,
                alignment: Alignment.topCenter,
                title: Text(LocaleKeys.reset_password_error.tr()),
                autoCloseDuration: const Duration(seconds: 3),
                showProgressBar: false,
                primaryColor: Colors.white,
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              );
            }
          },
          builder: (context, state) {
            if (state is UpdatePasswordLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(40)),
                padding: EdgeInsets.all(Dimens.space20),
                margin: EdgeInsets.symmetric(
                    horizontal: Dimens.space20, vertical: Dimens.space30),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: Dimens.space10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.reset_password_set_new_password.tr(),
                          style: TextStyle(
                            fontFamily: 'VelaSans',
                              fontWeight: FontWeight.w400, fontSize: 32),
                        ),
                        SizedBox(),
                        AppTextField(
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return LocaleKeys.reset_password_enter_new_password.tr();
                              }
                              if (value.toString().trim() ==
                                  widget.oldPassword) {
                                return LocaleKeys.reset_password_new_password_not_similar.tr();
                              }
                              if (value.toString().length < 8) {
                                return LocaleKeys.reset_password_new_password_must_8.tr();
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(isObscureText
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye),
                              onPressed: () {
                                setState(() {
                                  isObscureText = !isObscureText;
                                });
                              },
                            ),
                            obscureText: isObscureText,
                            keyboardType: TextInputType.visiblePassword,
                            formatter: [
                              // TextMask(pallet: '+998 ## ### ## ##'),
                              // FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9\s]*$'),
                              //     replacementString: ""),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            title: LocaleKeys.reset_password_create_new_password.tr(),
                            controller: passwordController,
                            hintText: "********"),
                        SizedBox(),
                        AppTextField(
                            validator: (value) {
                              if (value.toString() != passwordController.text) {
                                return LocaleKeys.reset_password_rePassword_not_similar.tr();
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(isObscureText
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye),
                              onPressed: () {
                                setState(() {
                                  isObscureText = !isObscureText;
                                });
                              },
                            ),
                            obscureText: isObscureText,
                            keyboardType: TextInputType.visiblePassword,
                            formatter: [
                              // TextMask(pallet: '+998 ## ### ## ##'),
                              // FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9\s]*$'),
                              //     replacementString: ""),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            title: LocaleKeys.reset_password_repeat_password.tr(),
                            controller: rePasswordController,
                            hintText: "********"),
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
                              child: UniversalButton.filled(
                                height: Dimens.space60,
                                // icon: Icon(
                                //   CupertinoIcons.arrow_right,
                                //   color: Colors.white,
                                //   size: 25,
                                // ),
                                text: LocaleKeys.texts_continue.tr(),
                                textFontWeight: FontWeight.w400,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context
                                        .read<ResetPasswordCubit>()
                                        .updatePassword(
                                            oldPassword: widget.oldPassword,
                                            newPassword:
                                                passwordController.text.trim());
                                  }
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => SignUpSuccess(title: 'С возвращением!', text: 'Рады видеть вас снова',)));
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
          },
        ),
      ),
    );
  }
}
