import 'package:easy_localization/easy_localization.dart';
import 'package:wm_doctor/core/model/language_model.dart';

import '../../../../../core/widgets/export.dart';
import '../entity/regison_entity.dart';

void showDoctorTypeList({
  required BuildContext ctx,
  required ValueChanged<LanguageModel> onchange,

  required ValueChanged<String> realType,
}) async {
  List<String> doctorTypes = [];
  String currentLang = ctx.locale.languageCode;
  if (currentLang == "uz") {
    doctorTypes = DoctorTypes.uzbekSelect;
  } else if (currentLang == 'ru') {
    doctorTypes = DoctorTypes.russianSelect;
    // } else if (currentLang == 'en') {
    //   doctorTypes = DoctorTypes.english;
  }

  showModalBottomSheet(
    showDragHandle: true,
    context: ctx,
    enableDrag: true,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery
              .sizeOf(context)
              .width,
          maxHeight: MediaQuery
              .sizeOf(context)
              .height * 0.8,
          minHeight: MediaQuery
              .sizeOf(context)
              .height * 0.2,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              doctorTypes.length,
                  (index) {
                return ListTile(
                  onTap: () {
                    onchange(LanguageModel(uz: DoctorTypes.uzbekSelect[index],
                        ru: DoctorTypes.russianSelect[index]));
                    // onchange(LanguageModel(uz: DoctorTypes.uzbek[index], ru: DoctorTypes.russian[index], en: DoctorTypes.english[index]));

                    realType(DoctorTypes.specialistsSelect[index]);
                    Navigator.pop(context);
                  },
                  title: Text(doctorTypes[index]),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}