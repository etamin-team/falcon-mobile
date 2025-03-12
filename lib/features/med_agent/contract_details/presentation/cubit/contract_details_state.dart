part of 'contract_details_cubit.dart';

sealed class ContractDetailsState extends Equatable {
  const ContractDetailsState();
}

final class ContractDetailsInitial extends ContractDetailsState {
  @override
  List<Object> get props => [];
}

final class ContractDetailsLoading extends ContractDetailsState {
  @override
  List<Object> get props => [];
}

final class ContractDetailsSuccess extends ContractDetailsState {
  final DoctorsModel model;
  final ProfileDataModel? profileModel;
  final DistrictModel? districtModel;
  final WorkplaceModel? workplaceModel;
  final DoctorStatsModel? doctorStatsModel;
  final OutContractModel? outContractModel;

  const ContractDetailsSuccess(
      {required this.model,
      required this.districtModel,
      required this.profileModel,
      required this.workplaceModel,
      required this.doctorStatsModel,
      required this.outContractModel});

  @override
  List<Object> get props => [];
}

final class ContractDetailsError extends ContractDetailsState {
  final Failure failure;

  const ContractDetailsError({required this.failure});

  @override
  List<Object> get props => [failure];
}
