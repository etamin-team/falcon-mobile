part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {
  const SignInState();
}

final class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}

final class SignInLoading extends SignInState {
  @override
  List<Object> get props => [];
}

final class SignInSuccess extends SignInState {
  @override
  List<Object> get props => [];
}

final class SignInError extends SignInState {
  final Failure failure;

  const SignInError({required this.failure});

  @override
  List<Object> get props => [];
}
