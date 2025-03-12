import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/workplace/data/repository/workplace_repository_impl.dart';

import '../../../auth/sign_up/data/model/workplace_model.dart';

part 'workplace_state.dart';

class WorkplaceCubit extends Cubit<WorkplaceState> {
  final WorkplaceRepositoryImpl workplaceRepositoryImpl;

  WorkplaceCubit(this.workplaceRepositoryImpl) : super(WorkplaceInitial());

  void getWorkplace() async {
    emit(WorkplaceLoading());
    final request = await workplaceRepositoryImpl.getWorkplace();
    request.fold(
      (l) => emit(WorkplaceError(failure: l)),
      (r) => emit(WorkplaceSuccess(workplace: r)),
    );
  }
}
