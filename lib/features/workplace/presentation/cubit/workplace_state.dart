import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';

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
  List<Object> get props => [workplace];
}

final class WorkplaceError extends WorkplaceState {
  final Failure failure;

  const WorkplaceError({required this.failure});

  @override
  List<Object> get props => [failure];
}