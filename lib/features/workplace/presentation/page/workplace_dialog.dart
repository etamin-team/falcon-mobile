import 'package:flutter/material.dart';
import 'package:wm_doctor/core/styles/app_colors.dart';
import 'package:wm_doctor/features/workplace/presentation/page/workplace.dart';

showWorkplaceDialog(
    {required BuildContext ctx,
    required ValueChanged<String> name,
    required ValueChanged<int> id}) {
  showModalBottomSheet(
    context: ctx,
    enableDrag: true,
    showDragHandle: true,
    backgroundColor: AppColors.backgroundColor,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return WorkplacePage(name: name, id: id,);
    },
  );
}
