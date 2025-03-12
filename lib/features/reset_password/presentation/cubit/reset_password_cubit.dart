import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/reset_password/data/repository/reset_password_repository_impl.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepositoryImpl repositoryImpl;

  ResetPasswordCubit(this.repositoryImpl) : super(ResetPasswordInitial());

  void checkPassword({required String password}) async {
    emit(ResetPasswordLoading());
    final request = await repositoryImpl.checkPassword(password: password);
    request.fold(
      (l) => emit(ResetPasswordError(failure: l)),
      (r) => emit(ResetPasswordSuccess(check: r)),
    );
  }

  void updatePassword(
      {required String oldPassword, required String newPassword}) async {
    emit(UpdatePasswordLoading());
    final request = await repositoryImpl.updatePassword(
        oldPassword: oldPassword, newPassword: newPassword);
    request.fold(
      (l) => emit(UpdatePasswordError(failure: l)),
      (r) => emit(UpdatePasswordSuccess()),
    );
  }
}
