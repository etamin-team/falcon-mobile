import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/regions/data/repository/regions_repository_impl.dart';

import '../../../auth/sign_up/data/model/region_model.dart';

part 'regions_state.dart';

class RegionsCubit extends Cubit<RegionsState> {
  final RegionsRepositoryImpl regionsRepositoryImpl;

  RegionsCubit(this.regionsRepositoryImpl) : super(RegionsInitial());

  void getRegions() async {
    emit(RegionsLoading());
    final request = await regionsRepositoryImpl.getRegions();
    request.fold(
      (l) => emit(RegionsError(failure: l)),
      (r) => emit(RegionsSuccess(regions: r)),
    );
  }
}
