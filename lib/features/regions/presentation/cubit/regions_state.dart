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

final class RegionsError extends RegionsState {
  final Failure failure;

  const RegionsError({required this.failure});

  @override
  List<Object> get props => [failure];
}
