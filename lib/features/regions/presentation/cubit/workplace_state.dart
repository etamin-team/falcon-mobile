part of 'workplace_cubit.dart';

sealed class WorkPlaceState extends Equatable {
  const WorkPlaceState();
}


final class WorkPlaceInitial extends WorkPlaceState {
  @override
  List<Object> get props => [];
}
final class WorkPlaceLoading extends WorkPlaceState {
  @override
  List<Object> get props => [];
}
final class WorkPlaceClear extends WorkPlaceState {
  @override
  List<Object> get props => [];
}
final class WorkPlaceSuccess extends WorkPlaceState {
  final List<WorkPlaceDto> workplace;
  const WorkPlaceSuccess({required this.workplace});
  @override
  List<Object> get props => [];
}
final class WorkPlaceError extends WorkPlaceState {
  final Failure failure;

  const WorkPlaceError({required this.failure});

  @override
  List<Object> get props => [failure];
}