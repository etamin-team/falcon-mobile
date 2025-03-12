part of 'agent_profile_data_cubit.dart';

sealed class AgentProfileDataState extends Equatable {
  const AgentProfileDataState();
}

final class AgentProfileDataInitial extends AgentProfileDataState {
  @override
  List<Object> get props => [];
}

final class AgentProfileDataLoading extends AgentProfileDataState {
  @override
  List<Object> get props => [];
}

final class AgentProfileDataSuccess extends AgentProfileDataState {
  final AgentProfileDataModel model;

  const AgentProfileDataSuccess({required this.model});

  @override
  List<Object> get props => [];
}

final class AgentProfileDataError extends AgentProfileDataState {
  final Failure failure;

  const AgentProfileDataError({required this.failure});

  @override
  List<Object> get props => [failure];
}
