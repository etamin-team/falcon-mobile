import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/profile/data/model/out_contract_model.dart';
import 'package:wm_doctor/features/profile/data/repository/profile_repository_impl.dart';

part 'out_contract_state.dart';

class OutContractCubit extends Cubit<OutContractState> {
  final ProfileRepositoryImpl profileRepositoryImpl;

  OutContractCubit(this.profileRepositoryImpl) : super(OutContractInitial());

  Future<void> getOutContract() async {
    emit(OutContractLoading());
    final request = await profileRepositoryImpl.getOutContract();
    request.fold(
          (l) => emit(OutContractError(failure: l)),
          (r) => emit(OutContractSuccess(model: r)),
    );
  }
}