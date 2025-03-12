part of 'edit_contract_cubit.dart';

sealed class EditContractState extends Equatable {
  const EditContractState();
}

final class EditContractInitial extends EditContractState {
  @override
  List<Object> get props => [];
}

final class EditContractLoading extends EditContractState {
  @override
  List<Object> get props => [];
}

final class EditContractSuccess extends EditContractState {
  @override
  List<Object> get props => [];
}

final class EditContractError extends EditContractState {
  final Failure failure;

  const EditContractError({required this.failure});

  @override
  List<Object> get props => [];
}

final class AddEditContractLoading extends EditContractState {
  @override
  List<Object> get props => [];
}

final class AddEditContractSuccess extends EditContractState {

  @override
  List<Object> get props => [];
}

final class AddEditContractError extends EditContractState {
  final Failure failure;

  const AddEditContractError({required this.failure});

  @override
  List<Object> get props => [failure];
}
