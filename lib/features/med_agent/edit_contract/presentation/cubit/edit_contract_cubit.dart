import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/data/repository/edit_contract_repository_impl.dart';

import '../../../add_doctor/data/model/add_contract_model.dart';
import '../../data/model/edit_upload_model.dart';

part 'edit_contract_state.dart';

class EditContractCubit extends Cubit<EditContractState> {
  final EditContractRepositoryImpl editContractRepositoryImpl;

  EditContractCubit(this.editContractRepositoryImpl)
      : super(EditContractInitial());

  void updateContract({required EditUploadModel model}) async {
    emit(EditContractLoading());
    final request =
        await editContractRepositoryImpl.updateContract(model: model);
    request.fold(
      (l) => emit(EditContractError(failure: l)),
      (r) => emit(EditContractSuccess()),
    );
  }

  void addContract(
      {required AddContractModel model, required String doctorId}) async {
    emit(AddEditContractLoading());
    final request = await editContractRepositoryImpl.addContract(
        model: model, doctorId: doctorId);
    request.fold(
      (l) => emit(AddEditContractError(failure: l)),
      (r) => emit(AddEditContractSuccess()),
    );
  }
}
