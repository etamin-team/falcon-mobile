import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import 'package:wm_doctor/features/medicine/data/repository/medicine_repository_impl.dart';
import 'package:wm_doctor/features/medicine/data/repository/mnn_repository_impl.dart';

import '../../../create_template/data/model/medicine_model.dart';

part 'mnn_state.dart';

class MnnCubit extends Cubit<MnnState> {
  final MnnRepositoryImpl mnnRepositoryImpl;

  MnnCubit(this.mnnRepositoryImpl) : super(MnnInitial());
  getMnn() async {
    print("GET MNN LOADING ============>");
    emit(MnnLoading());
    final request=await mnnRepositoryImpl.getMnn();
    print("GET MNN REQUEST ============> $request");
    request.fold((l) => emit(MnnError(failure: l)), (r) => emit(MnnSuccess(list: r)),);
  }
}