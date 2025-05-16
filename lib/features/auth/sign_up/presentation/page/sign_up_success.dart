import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/page/sign_page.dart';

import '../../../../../gen/locale_keys.g.dart';
import '../../../../main/presentation/cubit/main_page_cubit.dart';
import '../../../../main/presentation/page/main_page.dart';
import '../widgets/language.dart';

class SignUpSuccessPage extends StatefulWidget {
  final String title;
  final String text;

  const SignUpSuccessPage({super.key, required this.title, required this.text});

  @override
  State<SignUpSuccessPage> createState() => _SignUpSuccessPageState();
}

class _SignUpSuccessPageState extends State<SignUpSuccessPage>   with SingleTickerProviderStateMixin {
  String title = "";
  String text = "";
  String buttonText = LocaleKeys.sign_up_start_work.tr();
  String status = "PENDING";
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isButtonDisabled = false;


  @override
  void initState() {
    super.initState();
    title = widget.title;
    text = widget.text;

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });
    // Trigger token check after short delay
    Future.delayed(Duration(milliseconds: 1000), () {
      context.read<MainPageCubit>().checkToken();
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      _controller.forward(from: 0);
    });


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          alignment: Alignment.center,
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
                  checkStatus(status: status, title: true),
                  style: TextStyle(
                      fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                ),
                Text(
                  checkStatus(status: status, title: false),
                  style: TextStyle(
                      fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w400,
                      fontSize: Dimens.space16),
                ),
                SizedBox(),
                InkWell(
                  onTap: isButtonDisabled
                      ? null
                      : () async {
                    setState(() {
                      isButtonDisabled = true;
                    });
                    _controller.forward(from: 0);

                    if (buttonText == LocaleKeys.sign_up_logout.tr()) {
                      await FlutterSecureStorage().deleteAll();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignPage()),
                            (route) => false,
                      );
                    } else {
                      context.read<MainPageCubit>().checkToken();
                    }

                    await Future.delayed(const Duration(seconds: 20));
                    setState(() {
                      isButtonDisabled = false;
                    });
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimens.space20, horizontal: Dimens.space30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [_animation.value, _animation.value],
                        colors: [
                          AppColors.blueColor,
                          Colors.grey.shade400,
                        ],
                      ),
                    ),
                    child: BlocConsumer<MainPageCubit, MainPageState>(
                      listener: (context, state) {
                        if (state is MainPageSuccess) {
                          status = state.status;

                          if (state.status == "ENABLED") {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage(fromCheck: true)),
                                  (route) => false,
                            );
                          }

                          if (state.status == "DECLINED") {
                            setState(() {
                              title = LocaleKeys.sign_up_declined_title.tr();
                              text = LocaleKeys.sign_up_declined_text.tr();
                              buttonText = LocaleKeys.sign_up_logout.tr();
                            });
                            toastification.show(
                              style: ToastificationStyle.flat,
                              context: context,
                              alignment: Alignment.topCenter,
                              title: Text(LocaleKeys.sign_up_declined_title.tr()),
                              autoCloseDuration: const Duration(seconds: 2),
                              showProgressBar: false,
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            );
                          }

                          if (state.status == "DISABLED") {
                            setState(() {
                              title = LocaleKeys.sign_up_disabled_title.tr();
                              text = LocaleKeys.sign_up_disabled_text.tr();
                              buttonText = LocaleKeys.sign_up_logout.tr();
                            });
                            toastification.show(
                              style: ToastificationStyle.flat,
                              context: context,
                              alignment: Alignment.topCenter,
                              title: Text(LocaleKeys.sign_up_disabled_title.tr()),
                              autoCloseDuration: const Duration(seconds: 2),
                              showProgressBar: false,
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            );
                          }

                          if (state.status == "PENDING") {
                            setState(() {
                              title = LocaleKeys.sign_up_pending_title.tr();
                              text = LocaleKeys.sign_up_pending_text.tr();
                              buttonText = LocaleKeys.sign_up_check_status.tr();
                            });
                            toastification.show(
                              style: ToastificationStyle.flat,
                              context: context,
                              icon: Icon(Icons.warning_amber, color: Colors.white,),
                              alignment: Alignment.topCenter,
                              title: Text(LocaleKeys.sign_up_pending_text.tr()),
                              autoCloseDuration: const Duration(seconds: 2),
                              showProgressBar: false,
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is MainPageLoading) {
                          return Center(
                            child: CircularProgressIndicator(color: AppColors.white),
                          );
                        }

                        return Row(
                          spacing: Dimens.space10,
                          children: [
                            Text(
                              status == "PENDING"
                                  ? LocaleKeys.sign_up_check_status.tr()
                                  : LocaleKeys.sign_up_logout.tr(),
                              style: TextStyle(
                                fontFamily: 'VelaSans',
                                fontWeight: FontWeight.w400,
                                fontSize: Dimens.space16,
                                color: AppColors.white,
                              ),
                            ),
                            Icon(CupertinoIcons.arrow_right, color: AppColors.white),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                UniversalButton.filled(
                  backgroundColor: AppColors.redAccent,
                  text: "Log Out",
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignPage()),
                          (route) => false,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String checkStatus({required String status, required bool title}) {
    print("----------------------------------------");
    print(status);
    print(title);
    if (status == "PENDING" && title) {
      return LocaleKeys.sign_up_pending_title.tr();
    } else if (status == "PENDING" && !title) {
      return LocaleKeys.sign_up_pending_text.tr();
    } else if (status == "DISABLED" && title) {
      return LocaleKeys.sign_up_disabled_title.tr();
    } else if (status == "DISABLED" && !title) {
      return LocaleKeys.sign_up_disabled_text.tr();
    } else if (status == "DECLINED" && title) {
      return LocaleKeys.sign_up_declined_title.tr();
    } else if (status == "DECLINED" && !title) {
      return LocaleKeys.sign_up_declined_text.tr();
    }

    return "";
  }
}
