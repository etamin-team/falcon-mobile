import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/regions/data/repository/regions_repository_impl.dart';
import '../../../med_agent/contract/data/model/contract_model.dart';


part 'workplace_state.dart';

class WorkPlaceCubit extends Cubit<WorkPlaceState> {
  final RegionsRepositoryImpl regionsRepositoryImpl;

  WorkPlaceCubit(this.regionsRepositoryImpl) : super(WorkPlaceInitial());

  void getWorkplacesByDistrictId(id) async {
    print("----------------------------------- doctor");
    print("WorkPlaceLoading:"+id.toString());

    emit(WorkPlaceLoading());
    final request = await regionsRepositoryImpl.getWorkplacesByDistrictId(id);
    request.fold(
          (l) => emit(WorkPlaceError(failure: l)),
          (r) => emit(WorkPlaceSuccess(workplace: r)),
    );
  }
  void clear() {
    emit(WorkPlaceClear());
  }
}
