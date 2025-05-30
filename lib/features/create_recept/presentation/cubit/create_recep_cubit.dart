import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/create_recept/data/repository/create_recep_repository_impl.dart';

import '../../data/model/recep_model.dart';

part 'create_recep_state.dart';

class CreateRecepCubit extends Cubit<CreateRecepState> {
  final CreateRecepRepositoryImpl createRecepRepositoryImpl;

  CreateRecepCubit(this.createRecepRepositoryImpl)
      : super(CreateRecepInitial());

  void saveRecep({required RecepModel model}) async {
    emit(CreateRecepLoading());
    print("_______________________________________________________________________");
    print('model');
    final request = await createRecepRepositoryImpl.saveRecep(model: model);
    request.fold(
      (l) => emit(CreateRecepError(failure: l)),
      (r) => emit(CreateRecepSuccess()),
    );
  }

  void chengeState() async {
    emit(CreateRecepInitial());
  }

  // void getTelegramUser({required String id}) async {
  //   emit(GetTelegramUserLoading());
  //   final request = await createRecepRepositoryImpl.getUserFromTelegram(id: id);
  //   request.fold(
  //     (l) => emit(GetTelegramUserError(failure: l)),
  //     (r) => emit(GetTelegramUserSuccess(model: r)),
  //   );
  // }
  //
  void sendTelegramData({required String number, required String message}) async {
    emit(SendTelegramLoading());
    print("_______________________________________________________________________");
    print('number');
    print(number);
    print('message');
    print(message);
    print("_______________________________________________________________________");
    final request =
        await createRecepRepositoryImpl.sendMessage(number: number, message: message);
    request.fold(
      (l) => emit(SendTelegramError(failure: l)),
      (r) => emit(SendTelegramSuccess()),
    );
  }
}
