part of 'last_doctor_cubit.dart';




sealed class LastDoctorState extends Equatable {
  const LastDoctorState();
}

final class LastDoctorInitial extends LastDoctorState {
  @override
  List<Object> get props => [];
}

final class LastDoctorLoading extends LastDoctorState {
  @override
  List<Object> get props => [];
}


final class LastDoctorSuccess extends LastDoctorState {
  final List<DoctorsModel> lastList;

  const LastDoctorSuccess({required this.lastList});

  @override
  List<Object> get props => [lastList];
}

final class LastDoctorError extends LastDoctorState {
  final Failure lastFailure;

  const LastDoctorError({required this.lastFailure});

  @override
  List<Object> get props => [lastFailure];
}