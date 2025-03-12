part of 'agent_home_cubit.dart';

sealed class AgentHomeState extends Equatable {
  const AgentHomeState();
}

final class AgentHomeInitial extends AgentHomeState {
  @override
  List<Object> get props => [];
}

final class AgentHomeLoading extends AgentHomeState {
  @override
  List<Object> get props => [];
}

final class AgentHomeSuccess extends AgentHomeState {
  final AgentGoalModel model;

  const AgentHomeSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class AgentHomeError extends AgentHomeState {
  final Failure failure;

  const AgentHomeError({required this.failure});

  @override
  List<Object> get props => [failure];
}
