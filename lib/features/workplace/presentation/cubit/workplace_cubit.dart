import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/features/workplace/domain/repository/workplace_repositort.dart';
import 'package:wm_doctor/features/workplace/presentation/cubit/workplace_state.dart';

class WorkplaceCubit extends Cubit<WorkplaceState> {
  final WorkplaceRepository repository;

  WorkplaceCubit(this.repository) : super(WorkplaceInitial());

  Future<void> getWorkplace(int regionId, int districtId) async {
    emit(WorkplaceLoading());
    final result = await repository.getWorkplace(regionId, districtId);
    result.fold(
          (failure) => emit(WorkplaceError(failure: failure)),
          (workplaces) => emit(WorkplaceSuccess(workplace: workplaces)),
    );
  }
}