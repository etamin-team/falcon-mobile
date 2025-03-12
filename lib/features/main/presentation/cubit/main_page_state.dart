part of 'main_page_cubit.dart';

sealed class MainPageState extends Equatable {
  const MainPageState();
}

final class MainPageInitial extends MainPageState {
  @override
  List<Object> get props => [];
}

final class MainPageLoading extends MainPageState {
  @override
  List<Object> get props => [];
}

final class MainPageSuccess extends MainPageState {
  final String token;
  final String role;
  final String status;

  const MainPageSuccess({required this.token, required this.role,required this.status});

  @override
  List<Object> get props => [token];
}

final class MainPageError extends MainPageState {
  final Failure failure;

  const MainPageError({required this.failure});

  @override
  List<Object> get props => [failure];
}
