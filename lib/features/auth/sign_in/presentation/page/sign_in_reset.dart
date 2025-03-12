import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/auth/sign_in/presentation/page/sign_in_reset_end.dart';

import '../../../../../core/widgets/export.dart';
import '../../../sign_up/presentation/widgets/language.dart';

class SignInReset extends StatefulWidget {
  const SignInReset({super.key});

  @override
  State<SignInReset> createState() => _SignInResetState();
}

class _SignInResetState extends State<SignInReset> {
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  bool isObscureText = true;
  int _remainingTime = 59; // Timerni boshlang'ich vaqti (30 soniya)
  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Avvalgi timerni bekor qilish
    }

    setState(() {
      _remainingTime = 59;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();

        }
      });
    });
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
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: false,
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
            child: SingleChildScrollView(
              child: Column(
                spacing: Dimens.space10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Восстановление аккаунта",
                    style: TextStyle(
                      fontFamily: 'VelaSans',
                        fontWeight: FontWeight.w400, fontSize: 32),
                  ),
                  SizedBox(),
                  AppTextField(
                      // suffixIcon: IconButton(
                      //   icon: Icon(isObscureText
                      //       ? CupertinoIcons.eye_slash
                      //       : CupertinoIcons.eye),
                      //   onPressed: () {
                      //     setState(() {
                      //       isObscureText = !isObscureText;
                      //     });
                      //   },
                      // ),
                      // obscureText: isObscureText,
                      keyboardType: TextInputType.text,
                      formatter: [
                        // TextMask(pallet: '+998 ## ### ## ##'),
                        // FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9\s]*$'),
                        //     replacementString: ""),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      title: "Логин или номер телефона",
                      controller: passwordController,
                      hintText: "Пишите сюда"),
                  SizedBox(),
                  Text(
                    "СМС код",
                    style: TextStyle(
                      fontSize: Dimens.space16,
                      fontWeight: FontWeight.w500,
                    ),
                  ).paddingOnly(left: Dimens.space4),
                  Pinput(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
                  Text(
                    "Вам должен прийти 4-х значный смс код подтверждения",
                    style: TextStyle(
                        fontSize: Dimens.space14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ).paddingOnly(left: Dimens.space4),
                  UniversalButton.filled(
                    backgroundColor: Colors.grey.shade200,
                    cornerRadius: 15,
                    textColor: Colors.black,
                    textFontWeight: FontWeight.w400,
                    fontSize: Dimens.space14,
                    text: "Новый код через $_remainingTime секунд",
                    onPressed: () {},
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
                                    builder: (context) => SignInResetEnd()));

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
  }
}
