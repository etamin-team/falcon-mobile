part of 'medicine_cubit.dart';

sealed class MedicineState extends Equatable {
  const MedicineState();
}

final class MedicineInitial extends MedicineState {
  @override
  List<Object> get props => [];
}

final class MedicineLoading extends MedicineState {
  @override
  List<Object> get props => [];
}

final class MedicineSuccess extends MedicineState {
  final List<MedicineModel> list;

  const MedicineSuccess({required this.list});

  @override
  List<Object> get props => [list];
}

final class MedicineError extends MedicineState {
  final Failure failure;

  const MedicineError({required this.failure});

  @override
  List<Object> get props => [];
}
