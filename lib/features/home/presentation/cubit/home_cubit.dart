import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/home/data/model/template_model.dart';
import 'package:wm_doctor/features/home/data/repository/home_repository_impl.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepositoryImpl homeRepositoryImpl;

  HomeCubit(this.homeRepositoryImpl) : super(HomeInitial());

  Future<void> getTemplate({
    required String saved,
    required String sortBy,
    required String searchText,
  }) async {
    try {
      emit(HomeGetTemplateLoading());
      // Add minimum delay for UX (optional, adjust as needed)
      await Future.delayed(const Duration(milliseconds: 300));

      final request = await homeRepositoryImpl.getTemplate(
        saved: saved,
        sortBy: sortBy,
        searchText: searchText,
      );

      request.fold(
            (failure) {
          emit(HomeGetTemplateError(failure: failure));
        },
            (templates) {
          emit(HomeGetTemplateSuccess(list: templates));
        },
      );
    } catch (e) {
      emit(HomeGetTemplateError(
        failure: Failure(errorMsg: e.toString(), statusCode: 500),
      ));
    }
  }

  Future<void> deleteTemplate({required int id}) async {
    try {
      emit(HomeGetTemplateLoading());
      // Add minimum delay for UX (optional, adjust as needed)
      await Future.delayed(const Duration(milliseconds: 300));

      final request = await homeRepositoryImpl.deleteTemplate(id: id);

      request.fold(
            (failure) {
          emit(HomeGetTemplateError(failure: failure));
        },
            (_) {
          // No need to emit HomeGetTemplateSuccess here; let getTemplate handle the refresh
          // Optionally emit a specific state for successful deletion if needed
        },
      );
    } catch (e) {
      emit(HomeGetTemplateError(
        failure: Failure(errorMsg: e.toString(), statusCode: 500),
      ));
    }
  }
}

// Extension to fix Failure message getter
extension FailureExtension on Failure {
  String get message => errorMsg; // Return errorMsg instead of null
}