import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/features/auth/sign_in/presentation/cubit/sign_in_cubit.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/text_mask.dart';
import '../../../../../core/widgets/export.dart';
import '../../../sign_up/presentation/page/sign_up_success.dart';
import '../../../sign_up/presentation/widgets/language.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    numberController.text = " ";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) async {
        if (state is SignInSuccess) {
          await SecureStorage().write(
              key: "number",
              value: numberController.text
                  .trim()
                  .replaceAll(" ", "")
                  .replaceAll("+", ""));
          await SecureStorage()
              .write(key: "password", value: passwordController.text.trim());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpSuccessPage(
                        title: LocaleKeys.sign_in_sign_in_title.tr(),
                        text: LocaleKeys.sign_in_sign_in_text.tr(),
                      )));
        }
        if (state is SignInError) {
          toastification.show(
            style: ToastificationStyle.flat,
            context: context,
            alignment: Alignment.topCenter,
            title: Text(state.failure.statusCode == 404
                ? LocaleKeys.sign_in_user_not_found.tr()
                : state.failure.statusCode == 401
                    ? LocaleKeys.sign_in_incorrect_password.tr()
                    : state.failure.errorMsg),
            autoCloseDuration: const Duration(seconds: 3),
            showProgressBar: false,
            primaryColor: Colors.white,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        if (state is SignInLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
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
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              // title: Image.asset(
              //   Assets.images.logo.path,
              //   height: 40,
              // ),
              toolbarHeight: Dimens.space100,
              automaticallyImplyLeading: false,
              forceMaterialTransparency: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    showLanguageChoice(ctx: context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.white),
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
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: Dimens.space10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.sign_in_enter_account.tr(),
                        style: TextStyle(
                          fontFamily: 'VelaSans',
                            fontWeight: FontWeight.w400, fontSize: 32),
                      ),
                      SizedBox(),
                      AppTextField(
                          validator: (value) {
                            if (value.toString().length < 12) {
                              return LocaleKeys.sign_in_enter_number.tr();
                            }
                            return null;
                          },
                          withDecoration: true,
                          prefixIcon: Text("+998 "),
                          hintColor: Colors.black,
                          onChanged: (value) {
                            // setState(() {
                            //   if(numberController.text.length<5){
                            //     numberController.text="+998";
                            //   }
                            // });
                          },
                          keyboardType: TextInputType.phone,
                          formatter: [
                            // CustomPhoneFormatter(),
                            TextMask(pallet: '## ### ## ##'),
                            // FilteringTextInputFormatter.allow(
                            //     RegExp(r'^\+?[0-9\s]*$'),
                            //     replacementString: ""),
                            LengthLimitingTextInputFormatter(12),
                          ],
                          title: LocaleKeys.sign_in_phone_number.tr(),
                          controller: numberController,
                          hintText: ""),
                      SizedBox(),
                      AppTextField(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return LocaleKeys.sign_in_enter_password.tr();
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
                          title: LocaleKeys.sign_in_password.tr(),
                          controller: passwordController,
                          hintText: "********"),
                      SizedBox(),
                      // TextButton(
                      //   child: Text(
                      //     "Забыли пароль?",
                      //     style: GoogleFonts.poppins(
                      //         fontWeight: FontWeight.w400,
                      //         fontSize: Dimens.space14,
                      //         color: Colors.grey),
                      //   ),
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => SignInReset()));
                      //   },
                      // ),
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
                              fontSize: 14,
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
                                  context.read<SignInCubit>().login(
                                      number:
                                          "998${numberController.text.trim().replaceAll(" ", "").replaceAll("+", "")}",
                                      password: passwordController.text.trim());
                                }
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
          ),
        );
      },
    );
  }
}
