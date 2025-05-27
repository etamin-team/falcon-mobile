import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/profile/data/model/statistics_model.dart';
import 'package:wm_doctor/features/profile/data/repository/profile_repository_impl.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final ProfileRepositoryImpl profileRepositoryImpl;

  StatisticsCubit(this.profileRepositoryImpl) : super(StatisticsInitial());

  Future<void> getStatistics() async {
    emit(StatisticsLoading());
    final request = await profileRepositoryImpl.getStatistics();
    request.fold(
          (l) => emit(StatisticsError(failure: l)),
          (r) => emit(StatisticsSuccess(model: r)),
    );
  }
}