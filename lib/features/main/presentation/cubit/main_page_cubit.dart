import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/main/data/repository/main_repository_impl.dart';

import '../../../../core/services/secure_storage.dart';

part 'main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  final MainRepositoryImpl mainRepositoryImpl;

  MainPageCubit(this.mainRepositoryImpl) : super(MainPageInitial());

  void checkToken() async {
    emit(MainPageLoading());
    final request = await mainRepositoryImpl.checkToken();
    request.fold(
      (l) => emit(MainPageError(failure: l)),
      (r) async{
        String token = await SecureStorage().read(key: "accessToken") ?? "";
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        await SecureStorage().write(key: "userId", value: decodedToken["sub"]);
        await SecureStorage().write(key: "role", value: decodedToken["role"]);
        emit(MainPageSuccess(token: r, role: decodedToken["role"], status: decodedToken["status"]));
      },
    );
  }
}
