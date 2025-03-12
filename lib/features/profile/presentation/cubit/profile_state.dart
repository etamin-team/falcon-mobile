part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

final class ProfileLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

final class ProfileSuccess extends ProfileState {
  final UserModel model;
  final DistrictModel? districtModel;
  final WorkplaceModel? workplaceModel;

  const ProfileSuccess({required this.model,required this.districtModel,required this.workplaceModel});

  @override
  List<Object> get props => [];
}

final class ProfileError extends ProfileState {
  final Failure failure;

  const ProfileError({required this.failure});

  @override
  List<Object> get props => [];
}
