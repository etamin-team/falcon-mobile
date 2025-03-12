part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}

final class SignUpGetDataLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

final class SignUpGetDataSuccess extends SignUpState {
  final List<RegionModel> regions;
  final List<WorkplaceModel> workplace;

  const SignUpGetDataSuccess({required this.regions, required this.workplace});

  @override
  List<Object> get props => [regions];
}

final class SignUpGetDataError extends SignUpState {
  final Failure failure;

  const SignUpGetDataError({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class SignUpLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess();

  @override
  List<Object> get props => [];
}

final class SignUpError extends SignUpState {
  final Failure failure;

  const SignUpError({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class SignUpLoginLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

final class SignUpLoginSuccess extends SignUpState {
  final String status;

  const SignUpLoginSuccess({required this.status});

  @override
  List<Object> get props => [];
}

final class SignUpLoginError extends SignUpState {
  final Failure failure;

  const SignUpLoginError({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class SignUpCheckNumberLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

final class SignUpCheckNumberSuccess extends SignUpState {
  final bool isExist;

  const SignUpCheckNumberSuccess({required this.isExist});

  @override
  List<Object> get props => [isExist];
}

final class SignUpCheckNumberError extends SignUpState {
  final Failure failure;

  const SignUpCheckNumberError({required this.failure});

  @override
  List<Object> get props => [failure];
}
