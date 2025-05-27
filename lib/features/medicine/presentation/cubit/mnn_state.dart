part of 'mnn_cubit.dart';

abstract class MnnState extends Equatable {
  final List<MnnModel> list;
  const MnnState(this.list);

  @override
  List<Object> get props => [list];
}

class MnnInitial extends MnnState {
  MnnInitial() : super([]);
}

class MnnLoading extends MnnState {
  MnnLoading(List<MnnModel> list) : super(list);
}

class MnnSuccess extends MnnState {
  MnnSuccess(List<MnnModel> list) : super(list);
}

class MnnError extends MnnState {
  final String errorMsg;

  MnnError(this.errorMsg, List<MnnModel> list) : super(list);
}