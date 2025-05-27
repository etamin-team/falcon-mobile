import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/doctors_model.dart';
import 'package:wm_doctor/features/med_agent/home/data/repository/agent_home_repository_impl.dart';

part 'last_doctor_state.dart';



class LastDoctorCubit extends Cubit<LastDoctorState> {
  final AgentHomeRepositoryImpl agentHomeRepositoryImpl;

  LastDoctorCubit(this.agentHomeRepositoryImpl) : super(LastDoctorInitial());

  void getDoctors() async {
    emit(LastDoctorLoading());
    final request = await agentHomeRepositoryImpl.getDoctors();
    request.fold(
          (l) => emit(LastDoctorError(lastFailure: l)),
          (r) => emit(LastDoctorSuccess(lastList: r)),
    );
  }

}