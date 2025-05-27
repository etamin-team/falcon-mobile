import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/regions/data/repository/regions_repository_impl.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../auth/sign_up/data/model/region_model.dart';
import '../../../med_agent/contract/data/model/contract_model.dart';

part 'regions_state.dart';

class RegionsCubit extends Cubit<RegionsState> {
  final RegionsRepositoryImpl regionsRepositoryImpl;

  RegionsCubit(this.regionsRepositoryImpl) : super(RegionsInitial());

  void getRegions() async {
    emit(RegionsLoading());

    String? token = await SecureStorage().read(key: "accessToken");

    if (token == null || token.isEmpty) {
      final request = await regionsRepositoryImpl.getRegions();
      request.fold(
            (l) => emit(RegionsError(failure: l)),
            (r) => emit(RegionsSuccess(regions: r)), // Assumes getRegions returns List<RegionModel>
      );
      return;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String id = decodedToken["regionId"]?.toString() ?? "";

    if (id.isNotEmpty) {
      final request = await regionsRepositoryImpl.getRegionById(id);
      request.fold(
            (l) => emit(RegionsError(failure: l)),
            (r) => emit(RegionsSuccess(regions: r)),
      );
    } else {
      final request = await regionsRepositoryImpl.getRegions();
      request.fold(
            (l) => emit(RegionsError(failure: l)),
            (r) => emit(RegionsSuccess(regions: r)), // Assumes getRegions returns List<RegionModel>
      );
    }
  }

  void getDistrictsByRegionID(id) async {
    emit(RegionsLoading());
    final request = await regionsRepositoryImpl.getDistrictsByRegionID(id);
    request.fold(
          (l) => emit(DistrictsError(failure: l)),
          (r) => emit(DistrictsSuccess(districts: r)),
    );
  }
  void getWorkplacesByDistrictId(id) async {
    emit(RegionsLoading());
    final request = await regionsRepositoryImpl.getWorkplacesByDistrictId(id);
    request.fold(
          (l) => emit(WorkplaceErrorr(failure: l)),
          (r) => emit(WorkplaceSuccesss(workplace: r)),
    );
  }
  void clear() {
    emit(RegionClear());
  }
}
