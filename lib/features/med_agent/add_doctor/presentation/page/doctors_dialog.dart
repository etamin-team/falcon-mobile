import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/styles/app_colors.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/presentation/page/doctors.dart';

import '../../../../regions/presentation/cubit/regions_cubit.dart';
import '../../../home/presentation/cubit/doctor/doctor_cubit.dart'; // Import DoctorCubit

void showDoctor({
  required BuildContext ctx,
  required ValueChanged<String> id,
  required ValueChanged<String> firstName,
  required ValueChanged<String> lastName,
  required ValueChanged<String> type,
  required ValueChanged<String> level,
  required ValueChanged<String> phone,
}) {
  showModalBottomSheet(
    context: ctx,
    enableDrag: true,
    showDragHandle: true,
    backgroundColor: AppColors.backgroundColor,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return DoctorsPageD(
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        id: id,
        type: type,
        level: level,
      );
    },
  ).then((_) {
    // Call clear on DoctorCubit when the modal is dismissed
    ctx.read<DoctorCubit>().clear();
    ctx.read<RegionsCubit>().clear();
  });
}