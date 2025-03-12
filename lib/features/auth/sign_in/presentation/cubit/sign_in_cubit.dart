import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/auth/sign_in/data/repository/sign_in_repository_impl.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInRepositoryImpl signInzRepositoryImpl;

  SignInCubit(this.signInzRepositoryImpl) : super(SignInInitial());

  void login({required String number, required String password}) async {
    emit(SignInLoading());
    final request =
        await signInzRepositoryImpl.login(number: number, password: password);
    request.fold(
      (l) => emit(SignInError(failure: l)),
      (r) => emit(SignInSuccess()),
    );
  }
}
