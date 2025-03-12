import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/profile/data/model/agent_profile_data_model.dart';
import 'package:wm_doctor/features/med_agent/profile/data/repository/agent_profile_repository_impl.dart';

part 'agent_profile_data_state.dart';

class AgentProfileDataCubit extends Cubit<AgentProfileDataState> {
  final AgentProfileRepositoryImpl agentProfileRepositoryImpl;

  AgentProfileDataCubit(this.agentProfileRepositoryImpl)
      : super(AgentProfileDataInitial());

  void getProfileData() async {
    emit(AgentProfileDataLoading());
    final request = await agentProfileRepositoryImpl.getProfileData();
    request.fold(
      (l) => emit(AgentProfileDataError(failure: l)),
      (r) => emit(AgentProfileDataSuccess(model: r)),
    );
  }
}
