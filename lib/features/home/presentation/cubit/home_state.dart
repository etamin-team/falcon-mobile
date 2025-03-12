part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeGetTemplateLoading extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeGetTemplateSuccess extends HomeState {
  final List<TemplateModel> list;
  const HomeGetTemplateSuccess({required this.list});
  @override
  List<Object> get props => [list];
}

final class HomeGetTemplateError extends HomeState {
  final Failure failure;
  const HomeGetTemplateError({required this.failure});
  @override
  List<Object> get props => [failure];
}