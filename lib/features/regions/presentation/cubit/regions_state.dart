part of 'regions_cubit.dart';

sealed class RegionsState extends Equatable {
  const RegionsState();
}

final class RegionsInitial extends RegionsState {
  @override
  List<Object> get props => [];
}

final class RegionsLoading extends RegionsState {
  @override
  List<Object> get props => [];
}

final class RegionsSuccess extends RegionsState {
  final List<RegionModel> regions;
  const RegionsSuccess({required this.regions});
  @override
  List<Object> get props => [];
}
final class DistrictsSuccess extends RegionsState {
  final List<District> districts;
  const DistrictsSuccess({required this.districts});
  @override
  List<Object> get props => [];
}
final class RegionClear extends RegionsState {
  @override
  List<Object> get props => [];
}
final class DistrictsError extends RegionsState {
  final Failure failure;

  const DistrictsError({required this.failure});

  @override
  List<Object> get props => [failure];
}
final class RegionsError extends RegionsState {
  final Failure failure;

  const RegionsError({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class WorkplaceSuccesss extends RegionsState {
  final List<WorkPlaceDto> workplace;
  const WorkplaceSuccesss({required this.workplace});
  @override
  List<Object> get props => [];
}
final class WorkplaceErrorr extends RegionsState {
  final Failure failure;

  const WorkplaceErrorr({required this.failure});

  @override
  List<Object> get props => [failure];
}
