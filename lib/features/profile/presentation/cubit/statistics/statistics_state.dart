part of 'statistics_cubit.dart';

sealed class StatisticsState extends Equatable {
  const StatisticsState();
}

final class StatisticsInitial extends StatisticsState {
  @override
  List<Object> get props => [];
}

final class StatisticsLoading extends StatisticsState {
  @override
  List<Object> get props => [];
}

final class StatisticsSuccess extends StatisticsState {
  final DoctorStatsModel model;

  const StatisticsSuccess({required this.model});

  @override
  List<Object> get props => [model];
}

final class StatisticsError extends StatisticsState {
  final Failure failure;

  const StatisticsError({required this.failure});

  @override
  List<Object> get props => [failure];
}
