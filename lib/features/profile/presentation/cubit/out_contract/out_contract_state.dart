part of 'out_contract_cubit.dart';

sealed class OutContractState extends Equatable {
  const OutContractState();
}

final class OutContractInitial extends OutContractState {
  @override
  List<Object> get props => [];
}

final class OutContractLoading extends OutContractState {
  @override
  List<Object> get props => [];
}

final class OutContractSuccess extends OutContractState {
  final OutContractModel model;

  const OutContractSuccess({required this.model});

  @override
  List<Object> get props => [];
}

final class OutContractError extends OutContractState {
  final Failure failure;

  const OutContractError({required this.failure});

  @override
  List<Object> get props => [];
}
