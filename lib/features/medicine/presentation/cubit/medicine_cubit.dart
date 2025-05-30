import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/medicine/data/repository/medicine_repository_impl.dart';

import '../../../create_template/data/model/medicine_model.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {

  final MedicineRepositoryImpl medicineRepositoryImpl;

  MedicineCubit(this.medicineRepositoryImpl) : super(MedicineInitial());

  void getMedicine() async {
    emit(MedicineLoading());
    final request = await medicineRepositoryImpl.getMedicine();
    request.fold((l) => emit(MedicineError(failure: l)), (r) => emit(MedicineSuccess(list: r)),);
  }
}