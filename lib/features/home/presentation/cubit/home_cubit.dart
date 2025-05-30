import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/home/data/model/template_model.dart';
import 'package:wm_doctor/features/home/data/repository/home_repository_impl.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepositoryImpl homeRepositoryImpl;

  HomeCubit(this.homeRepositoryImpl) : super(HomeInitial());

  void getTemplate(
      {required String saved, required String sortBy, required String searchText}) async {
    try {
      emit(HomeGetTemplateLoading());
      print("✅ HomeCubit: API so‘rov yuborilmoqda...");

      final request = await homeRepositoryImpl.getTemplate(
          saved: saved, sortBy: sortBy, searchText: searchText);

      request.fold(
            (l) {
          print("❌ API Xato: ${l.message}");
          emit(HomeGetTemplateError(failure: l));
        },
            (r) {
          print("✅ API Javob: ${r.length} ta template olindi.");
          emit(HomeGetTemplateSuccess(list: r));
        },
      );
    } catch (e) {
      print("❌ HomeCubit Exception: $e");
      emit(HomeGetTemplateError(
          failure: Failure(errorMsg: e.toString(), statusCode: 500,)));
    }
  }

  void deleteTemplate(
      {required int id}) async {
    try {
      emit(HomeGetTemplateLoading());
      print("✅ HomeCubit: API so‘rov yuborilmoqda...");

      final request = await homeRepositoryImpl.deleteTemplate(id: id);

      request.fold(
            (l) {
          print("❌ API Xato: ${l.message}");
          emit(HomeGetTemplateError(failure: l));
        },
            (r) {
          print("✅ API Javob: ${r.length} ta template olindi.");
          emit(HomeGetTemplateSuccess(list: r));
        },
      );
    } catch (e) {
      print("❌ HomeCubit Exception: $e");
      emit(HomeGetTemplateError(
          failure: Failure(errorMsg: e.toString(), statusCode: 500,)));
    }
  }
}

extension on Failure {
  get message => null;
}