import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/page/sign_up.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/widgets/language.dart';

import '../../../../../core/widgets/export.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../../../../../main.dart';
import '../../../../regions/presentation/cubit/regions_cubit.dart';
import '../../../../workplace/presentation/cubit/workplace_cubit.dart';
import '../../../sign_in/presentation/page/sign_in.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  bool isDialogOpen = false;
  bool isDataDownload=false;
  late StreamSubscription<InternetConnectionStatus> _subscription;
  @override
  void initState() {
    _subscription = connectionChecker.onStatusChange.listen(
          (status) {

        if (status == InternetConnectionStatus.connected) {
          debugPrint("internet ulandi ✅=============================");
          if (isDialogOpen) {
            // Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
            isDialogOpen = false;
          }
          if(!isDataDownload){

            context.read<RegionsCubit>().getRegions();
            context.read<WorkplaceCubit>().getWorkplace();
          }
          internet = true;
        } else {
          debugPrint("❌ internet uzildi =============================");
          internet = false;
          // showInternetDialog(context);
          isDialogOpen=true;
        }

      },
    );
    context.read<RegionsCubit>().getRegions();
    context.read<WorkplaceCubit>().getWorkplace();
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
                  LocaleKeys.texts_welcome.tr(),
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w400, fontSize: 32),
                ),
                SizedBox(),
                SizedBox(),
                Row(
                  spacing: Dimens.space10,
                  children: [
                    Expanded(
                      flex: 1,
                      child: UniversalButton.filled(
                        fontSize: 12,
                        height: Dimens.space60,
                        text: LocaleKeys.texts_sign_up.tr(),
                        textFontWeight: FontWeight.w400,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: UniversalButton.outline(

                        height: Dimens.space60,
                        textFontWeight: FontWeight.w400,
                        text: LocaleKeys.texts_sign_in.tr(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
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
