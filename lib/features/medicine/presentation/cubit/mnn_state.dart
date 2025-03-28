part of 'mnn_cubit.dart';


sealed class MnnState extends Equatable {
  const MnnState();
}

final class MnnInitial extends MnnState {
  @override
  List<Object> get props => [];
}

final class MnnLoading extends MnnState {
  @override
  List<Object> get props => [];
}

final class MnnSuccess extends MnnState {
  final List<MnnModel> list;

  const MnnSuccess({required this.list});

  @override
  List<Object> get props => [list];
}

final class MnnError extends MnnState {
  final Failure failure;

  const MnnError({required this.failure});

  @override
  List<Object> get props => [];
}