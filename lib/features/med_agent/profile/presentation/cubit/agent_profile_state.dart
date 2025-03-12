part of 'agent_profile_cubit.dart';

sealed class AgentProfileState extends Equatable {
  const AgentProfileState();
}

final class AgentProfileInitial extends AgentProfileState {
  @override
  List<Object> get props => [];
}

final class AgentProfileLoading extends AgentProfileState {
  @override
  List<Object> get props => [];
}

final class AgentProfileSuccess extends AgentProfileState {
  final UserModel model;

  const AgentProfileSuccess({required this.model});

  @override
  List<Object> get props => [];
}

final class AgentProfileError extends AgentProfileState {
  final Failure failure;

  const AgentProfileError({required this.failure});

  @override
  List<Object> get props => [];
}
