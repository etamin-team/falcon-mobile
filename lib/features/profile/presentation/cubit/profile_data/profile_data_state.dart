part of 'profile_data_cubit.dart';

sealed class ProfileDataState extends Equatable {
  const ProfileDataState();
}

final class ProfileDataInitial extends ProfileDataState {
  @override
  List<Object> get props => [];
}

final class ProfileDataLoading extends ProfileDataState {
  @override
  List<Object> get props => [];
}

final class ProfileDataSuccess extends ProfileDataState {
  final ProfileDataModel model;

  const ProfileDataSuccess({required this.model});

  @override
  List<Object> get props => [];
}

final class ProfileDataError extends ProfileDataState {
  final Failure failure;

  const ProfileDataError({required this.failure});

  @override
  List<Object> get props => [];
}
