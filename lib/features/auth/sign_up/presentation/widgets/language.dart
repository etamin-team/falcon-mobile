import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/widgets/export.dart';

showLanguageChoice({required BuildContext ctx}) {
  String currentLang = ctx.locale.languageCode;


  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    showDragHandle: true,
    context: ctx,
    builder: (context) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(

              secondary: SvgPicture.asset(
                Assets.icons.uz,
                height: 30,
                width: 30,
              ),
              title: Text("O'zbekcha"),
              value: currentLang == "uz",
              groupValue: true,
              onChanged: (value) {
                ctx.setLocale(Locale("uz"));
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              secondary: SvgPicture.asset(
                Assets.icons.ru,
                height: 30,
                width: 30,
              ),
              title: Text("Русский"),
              value: currentLang == "ru",
              groupValue: true,
              onChanged: (value) {
                ctx.setLocale(Locale("ru"));
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              secondary: SvgPicture.asset(
                Assets.icons.usa,
                height: 30,
                width: 30,
              ),
              title: Text("English"),
              value: currentLang == "en",
              groupValue: true,
              onChanged: (value) {
                ctx.setLocale(Locale("en"));
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: Dimens.space30,
            ),
          ],
        ),
      );
    },
  );
}
