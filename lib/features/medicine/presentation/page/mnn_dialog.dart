import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/styles/app_colors.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_page.dart';
import 'package:wm_doctor/features/medicine/presentation/page/mnn_page.dart';

import '../cubit/mnn_cubit.dart';

showMNN({
  required BuildContext ctx,
  required ValueChanged<MnnModel> model,
  required List<MnnModel> mnn,
  required List medicine,
  required List<MnnModel> initialSelectedItems,
  required Function(List<MnnModel>) onSelectionComplete,
}) {
  print("MNN DIALOG OPENED");
  showModalBottomSheet(
    context: ctx,
    enableDrag: true,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: AppColors.backgroundColor,
    builder: (context) {
      return MNNPage(
        mnn: mnn,
        model: model,
        initialSelectedItems: initialSelectedItems,
        onSelectionComplete: onSelectionComplete,
      );
    },
  );
}