import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/profile/data/repository/agent_profile_repository_impl.dart';
import 'package:wm_doctor/features/profile/data/model/user_model.dart';

part 'agent_profile_state.dart';

class AgentProfileCubit extends Cubit<AgentProfileState> {
  final AgentProfileRepositoryImpl agentProfileRepositoryImpl;

  AgentProfileCubit(this.agentProfileRepositoryImpl)
      : super(AgentProfileInitial());


}
