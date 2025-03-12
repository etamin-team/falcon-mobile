import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/page/sign_up_success.dart';

import '../../../../../core/widgets/export.dart';
import '../../../sign_up/presentation/widgets/language.dart';

class SignInFull extends StatefulWidget {
  const SignInFull({super.key});

  @override
  State<SignInFull> createState() => _SignInFullState();
}

class _SignInFullState extends State<SignInFull> {
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  bool isObscureText = true;
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

                  "Завершите \nнастройку",
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w400, fontSize: 32),
                ),
                SizedBox(),
                Text(
                  "Вы были зарегистрированы администратором. Пожалуйста, смените временный пароль на ваш собственный.",
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w400, fontSize: Dimens.space18,color: Colors.grey),
                ),
                SizedBox(),
                AppTextField(
                  hintColor: Colors.black,
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
                    title: "Придумайте новый пароль",
                    controller: passwordController,
                    hintText: "123456"),
                SizedBox(),
                AppTextField(
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
                    title: "Подтвердите пароль",
                    controller: rePasswordController,
                    hintText: "123456"),
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
                        icon: Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.white,
                          size: 25,
                        ),
                        text: "Далее",
                        textFontWeight: FontWeight.w400,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpSuccessPage(title: 'С возвращением!', text: 'Рады видеть вас снова',)));
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
