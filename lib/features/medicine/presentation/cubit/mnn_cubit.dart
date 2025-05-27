import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';

import '../../domain/repository/mnn_repository.dart';

part 'mnn_state.dart';

class MnnCubit extends Cubit<MnnState> {
  final MnnRepository repository;
  List<MnnModel> allItems = [];

  MnnCubit(this.repository) : super(MnnInitial());

  Future<void> getMnn({required int page, required int size}) async {
    if (state is MnnLoading && page != 1) return; // Prevent concurrent loads
    emit(MnnLoading(allItems));
    final Either<Failure, List<MnnModel>> result =
    await repository.getMnn(page: page, size: size);
    result.fold(
          (failure) => emit(MnnError(failure.errorMsg, allItems)),
          (newItems) {
        allItems = page == 1 ? newItems : [...allItems, ...newItems];
        emit(MnnSuccess(allItems));
      },
    );
  }

  Future<void> resetAndGetMnn({required int page, required int size}) async {
    allItems = [];
    await getMnn(page: page, size: size);
  }
}