part of 'add_doctor_cubit.dart';

sealed class AddDoctorState extends Equatable {
  const AddDoctorState();
}

final class AddDoctorInitial extends AddDoctorState {
  @override
  List<Object> get props => [];
}
final class AddDoctorLoading extends AddDoctorState {
  @override
  List<Object> get props => [];
}
final class AddDoctorSuccess extends AddDoctorState {
  @override
  List<Object> get props => [];
}
final class AddDoctorError extends AddDoctorState {
  final Failure failure;
  const AddDoctorError({required this.failure});

  @override
  List<Object> get props => [failure];
}
