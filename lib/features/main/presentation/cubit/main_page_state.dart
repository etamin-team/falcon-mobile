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
  final int selectedIndex;

  const MainPageSuccess({
    required this.token,
    required this.role,
    required this.status,
    required this.selectedIndex,
  });

  @override
  List<Object> get props => [
        token,
        role,
        status,
        selectedIndex,
      ];

  MainPageSuccess copyWith({
    String? token,
    String? role,
    String? status,
    int? selectedIndex,
  }) {
    return MainPageSuccess(
      token: token ?? this.token,
      role: role ?? this.role,
      status: status ?? this.status,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

final class MainPageError extends MainPageState {
  final Failure failure;

  const MainPageError({required this.failure});

  @override
  List<Object> get props => [failure];
}
