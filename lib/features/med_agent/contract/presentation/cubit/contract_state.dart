part of 'contract_cubit.dart';

sealed class ContractState extends Equatable {
  const ContractState();
}

final class ContractInitial extends ContractState {
  @override
  List<Object> get props => [];
}

final class ContractLoading extends ContractState {
  @override
  List<Object> get props => [];
}

final class ContractSuccess extends ContractState {
  final List<ContractModel> list;

  const ContractSuccess({required this.list});

  @override
  List<Object> get props => [list];
}

final class ContractError extends ContractState {
  final Failure failure;

  const ContractError({required this.failure});

  @override
  List<Object> get props => [failure];
}
