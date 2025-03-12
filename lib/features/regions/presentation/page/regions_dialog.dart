import 'package:flutter/material.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/core/styles/app_colors.dart';
import 'package:wm_doctor/features/regions/presentation/page/regions.dart';

showRegions(
    {required BuildContext ctx,
    required ValueChanged<LanguageModel> onChange,
    required ValueChanged<int> districtId}) {
  showModalBottomSheet(
    backgroundColor: AppColors.backgroundColor,
    showDragHandle: true,
    context: ctx,
    enableDrag: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return RegionsPage(
        onChange: onChange,
        districtId: districtId,
      );
    },
  );
}
