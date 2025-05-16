import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
          (l) {
        emit(MainPageError(failure: l));
      },
          (r) {
        _handleTokenSuccess(r);
      },
    );
  }

  Future<void> _handleTokenSuccess(String token) async {
    String tokenStr = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenStr);
    print("--------------------------------");
    print(decodedToken["status"]);
    print(decodedToken["role"]);

    await SecureStorage().write(key: "userId", value: decodedToken["sub"]);
    await SecureStorage().write(key: "role", value: decodedToken["role"]);

    emit(MainPageSuccess(
      token: token,
      role: decodedToken["role"],
      status: decodedToken["status"],
      selectedIndex: 0,
    ));
  }


  void changeSelectedIndex(int index) {
    debugPrint("ChangeSelectedIndex:::: $index");
    if (state is MainPageSuccess) {
      debugPrint("ChangeSelectedIndex IS state Success:::: $index");
      final currentState = state as MainPageSuccess;
      emit(currentState.copyWith(selectedIndex: index));
    }
  }
}
