import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';

import '../../gen/locale_keys.g.dart';
import '../network/interceptor.dart';
import '../widgets/export.dart';

void showInternetDialog(BuildContext context) {
  showDialog(
    context: navigatorKey.currentContext!,
    // Navigator orqali to‘g‘ri kontekstni olish
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.space30,vertical: Dimens.space50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(Assets.lottie.internet,
                    fit: BoxFit.cover,
                    height: MediaQuery.sizeOf(context).width / 2,
                    width: MediaQuery.sizeOf(context).width / 2),
                SizedBox(
                  height: Dimens.space30,
                ),
                Text(
                  LocaleKeys.texts_no_internet.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: Dimens.space18),
                ),
                Text(
                  LocaleKeys.texts_internet_text.tr(),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
