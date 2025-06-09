import 'package:easy_localization/easy_localization.dart';
import 'package:wm_doctor/core/model/language_model.dart';

import '../../../../../core/widgets/export.dart';
import '../entity/regison_entity.dart';

void showDoctorPositionList({
  required BuildContext ctx,
  required ValueChanged<LanguageModel> onchange,
}) async {
  List<String> doctorPositions = [];
  String currentLang = ctx.locale.languageCode;
  if (currentLang == "uz") {
    doctorPositions = DoctorTypes.doctorDegreesUz;
  } else if (currentLang == 'ru') {
    doctorPositions = DoctorTypes.doctorDegreesRu;
  }
  // }} else if (currentLang == 'en') {
  //   doctorPositions = DoctorTypes.doctorDegreesEn;
  // }

  showModalBottomSheet(
    showDragHandle: true,
    context: ctx,
    enableDrag: true,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width,
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          minHeight: MediaQuery.sizeOf(context).height * 0.2,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              doctorPositions.length,
              (index) {
                return ListTile(
                  onTap: () {
                    onchange(LanguageModel(
                        uz: DoctorTypes.doctorDegreesUz[index],
                        ru: DoctorTypes.doctorDegreesRu[index],
                        // en: DoctorTypes.doctorDegreesEn[index]
                    ));
                    Navigator.pop(context);
                  },
                  title: Text(doctorPositions[index]),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
