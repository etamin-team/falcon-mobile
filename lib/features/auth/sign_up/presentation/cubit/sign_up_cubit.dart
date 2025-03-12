import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/services/secure_storage.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/region_model.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';
import 'package:wm_doctor/features/auth/sign_up/data/repository/sign_up_repository_impl.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepositoryImpl signUpRepositoryImpl;
  List<WorkplaceModel> workplace = [];

  SignUpCubit(this.signUpRepositoryImpl) : super(SignUpInitial());

  void getSignUpData() async {
    emit(SignUpGetDataLoading());
    final request = await signUpRepositoryImpl.getRegions();
    final request2 = await signUpRepositoryImpl.getWorkplace();
    request2.fold(
      (l) {},
      (r) {
        workplace = r;
      },
    );
    request.fold(
      (l) => emit(SignUpGetDataError(failure: l)),
      (r) => emit(SignUpGetDataSuccess(regions: r, workplace: workplace)),
    );
  }

  void signUp({required Map<String, dynamic> data,required String number,required String password}) async {
    emit(SignUpLoading());
    final request = await signUpRepositoryImpl.signUp(data: data);
    request.fold(
      (l) => emit(SignUpError(failure: l)),
      (r) async{
        await SecureStorage().write(
            key: "number",
            value: number);
        await SecureStorage()
            .write(key: "password", value: password);
        final request = await signUpRepositoryImpl.login();
        request.fold(
              (l) => emit(SignUpLoginError(failure: l)),
              (r) async {
            String token = await SecureStorage().read(key: "accessToken") ?? "";
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
            String status = decodedToken["status"];
            await SecureStorage().write(key: "userId", value: decodedToken["sub"]);
            await SecureStorage().write(key: "role", value: decodedToken["role"]);
            return emit(SignUpSuccess());
          },
        );
        return emit(SignUpSuccess());
      },
    );
  }

  void login() async {
    emit(SignUpLoginLoading());
    final request = await signUpRepositoryImpl.login();
    request.fold(
      (l) => emit(SignUpLoginError(failure: l)),
      (r) async {
        String token = await SecureStorage().read(key: "accessToken") ?? "";
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String status = decodedToken["status"];
        await SecureStorage().write(key: "userId", value: decodedToken["sub"]);
        await SecureStorage().write(key: "role", value: decodedToken["role"]);
        emit(SignUpLoginSuccess(status: status));
      },
    );
  }

  void checkNumber({required String number}) async {
    emit(SignUpCheckNumberLoading());
    final request = await signUpRepositoryImpl.checkNumber(number: number);
    request.fold(
      (l) => emit(SignUpCheckNumberError(failure: l)),
      (r) => emit(SignUpCheckNumberSuccess(isExist: r)),
    );
  }
}
