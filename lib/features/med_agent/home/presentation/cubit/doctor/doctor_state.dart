part of 'doctor_cubit.dart';

sealed class DoctorState extends Equatable {
  const DoctorState();
}

final class DoctorInitial extends DoctorState {
  @override
  List<Object> get props => [];
}

final class DoctorLoading extends DoctorState {
  @override
  List<Object> get props => [];
}

final class DoctorSuccess extends DoctorState {
  final List<DoctorsModel> list;

  const DoctorSuccess({required this.list});

  @override
  List<Object> get props => [list];
}

final class DoctorError extends DoctorState {
  final Failure failure;

  const DoctorError({required this.failure});

  @override
  List<Object> get props => [failure];
}
