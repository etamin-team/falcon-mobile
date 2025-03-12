part of 'workplace_cubit.dart';

sealed class WorkplaceState extends Equatable {
  const WorkplaceState();
}

final class WorkplaceInitial extends WorkplaceState {
  @override
  List<Object> get props => [];
}

final class WorkplaceLoading extends WorkplaceState {
  @override
  List<Object> get props => [];
}

final class WorkplaceSuccess extends WorkplaceState {
  final List<WorkplaceModel> workplace;

  const WorkplaceSuccess({required this.workplace});

  @override
  List<Object> get props => [];
}

final class WorkplaceError extends WorkplaceState {
  final Failure failure;

  const WorkplaceError({required this.failure});

  @override
  List<Object> get props => [];
}
