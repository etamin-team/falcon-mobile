import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/styles/app_colors.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_page.dart';
import '../../../create_template/data/model/medicine_model.dart';

showMedicine({
  required BuildContext ctx,
  required ValueChanged<MedicineModel> model,
  required List<MedicineModel> medicine,
}) async {
  if (medicine.isEmpty) {
    toastification.show(
      context: ctx,
      title: Text("No medicines available"),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.flat,
      primaryColor: Colors.white,
      backgroundColor: Colors.redAccent,
      foregroundColor: Colors.white,
    );
    return;
  }
  showModalBottomSheet(
    context: ctx,
    enableDrag: true,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: AppColors.backgroundColor,
    builder: (context) {
      return MedicinePage(
        medicine: medicine,
        model: model,
      );
    },
  );
}