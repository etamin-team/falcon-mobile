import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/contract/data/model/contract_model.dart';
import 'package:wm_doctor/features/med_agent/contract/data/repository/contract_repository_impl.dart';

part 'contract_state.dart';

class ContractCubit extends Cubit<ContractState> {
  final ContractRepositoryImpl contractRepositoryImpl;

  ContractCubit(this.contractRepositoryImpl) : super(ContractInitial());

  void getContracts() async {
    emit(ContractLoading());
    final request = await contractRepositoryImpl.getContract();
    request.fold(
      (l) => emit(ContractError(failure: l)),
      (r) => emit(ContractSuccess(list: r)),
    );
  }
}
