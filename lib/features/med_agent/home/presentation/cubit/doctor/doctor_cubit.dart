import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/doctors_model.dart';
import 'package:wm_doctor/features/med_agent/home/data/repository/agent_home_repository_impl.dart';

part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final AgentHomeRepositoryImpl agentHomeRepositoryImpl;

  DoctorCubit(this.agentHomeRepositoryImpl) : super(DoctorInitial());


  void getDoctorsWithFilters(districtId, workplaceId, doctorType, withContracts) async {
    emit(DoctorLoading());
    final request = await agentHomeRepositoryImpl.getDoctorsWithFilters(districtId?.toString(), workplaceId?.toString(), doctorType?.toString(), withContracts?.toString());
    request.fold(
          (l) => emit(DoctorError(failure: l)),
          (r) => emit(DoctorSuccess(list: r)),
    );
  }
  void clear() {
    emit(DoctorClear());
  }
}

