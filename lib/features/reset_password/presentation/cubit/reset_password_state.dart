part of 'reset_password_cubit.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();
}

final class ResetPasswordInitial extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordLoading extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordSuccess extends ResetPasswordState {
  final bool check;

  const ResetPasswordSuccess({required this.check});

  @override
  List<Object> get props => [];
}

final class ResetPasswordError extends ResetPasswordState {
  final Failure failure;

  const ResetPasswordError({required this.failure});

  @override
  List<Object> get props => [];
}

final class UpdatePasswordLoading extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

final class UpdatePasswordSuccess extends ResetPasswordState {
  @override
  List<Object> get props => [];
}

final class UpdatePasswordError extends ResetPasswordState {
  final Failure failure;

  const UpdatePasswordError({required this.failure});

  @override
  List<Object> get props => [failure];
}
