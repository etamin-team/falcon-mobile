import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/features/med_agent/home/data/repository/agent_home_repository_impl.dart';

import '../../../../../core/error/failure.dart';
import '../../data/model/agent_goal_model.dart';

part 'agent_home_state.dart';

class AgentHomeCubit extends Cubit<AgentHomeState> {
  final AgentHomeRepositoryImpl agentHomeRepositoryImpl;

  AgentHomeCubit(this.agentHomeRepositoryImpl) : super(AgentHomeInitial());

  void getData() async {
    emit(AgentHomeLoading());
    final request = await agentHomeRepositoryImpl.getAgentGoal();
    request.fold(
      (l) => emit(AgentHomeError(failure: l)),
      (r) => emit(AgentHomeSuccess(model: r)),
    );
  }
}
