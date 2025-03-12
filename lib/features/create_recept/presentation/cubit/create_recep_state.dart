part of 'create_recep_cubit.dart';

sealed class CreateRecepState extends Equatable {
  const CreateRecepState();

  @override
  List<Object?> get props => [];
}

final class CreateRecepInitial extends CreateRecepState {}

final class CreateRecepLoading extends CreateRecepState {}

final class CreateRecepSuccess extends CreateRecepState {}

final class CreateRecepError extends CreateRecepState {
  final Failure failure;

  const CreateRecepError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class SendTelegramLoading extends CreateRecepState {}

final class SendTelegramSuccess extends CreateRecepState {}

final class SendTelegramError extends CreateRecepState {
  final Failure failure;

  const SendTelegramError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
