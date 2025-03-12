import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/contract_details/data/repository/contract_details_repository_impl.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/doctors_model.dart';

import '../../../../auth/sign_up/data/model/workplace_model.dart';
import '../../../../profile/data/model/out_contract_model.dart';
import '../../../../profile/data/model/profile_data_model.dart';
import '../../../../profile/data/model/statistics_model.dart';
import '../../../../regions/data/model/district_model.dart';

part 'contract_details_state.dart';

class ContractDetailsCubit extends Cubit<ContractDetailsState> {
  final ContractDetailsRepositoryImpl contractDetailsRepositoryImpl;

  ContractDetailsCubit(this.contractDetailsRepositoryImpl)
      : super(ContractDetailsInitial());

  void getDoctorData({required String id}) async {
    ProfileDataModel? profileModel;
    WorkplaceModel? workplaceModel;
    DistrictModel? districtModel;
    DoctorStatsModel? doctorStatsModel;
    OutContractModel? outContractModel;
    emit(ContractDetailsLoading());
    final request = await contractDetailsRepositoryImpl.getDoctors(id: id);
    request.fold(
      (l) => emit(ContractDetailsError(failure: l)),
      (r) async {
        final request2 =
            await contractDetailsRepositoryImpl.getProfileData(id: id);
        request2.fold(
          (l) {},
          (r) => profileModel = r,
        );
        final request3 = await contractDetailsRepositoryImpl.getWorkplace(
            id: r.workplaceId ?? 0);
        request3.fold(
          (l) {},
          (r) => workplaceModel = r,
        );
        final request4 =
            await contractDetailsRepositoryImpl.getOutContract(id: id);
        request4.fold(
          (l) {},
          (r) => outContractModel = r,
        );
        final request5 =
            await contractDetailsRepositoryImpl.getStatistics(id: id);
        request5.fold(
          (l) {},
          (r) => doctorStatsModel = r,
        );
        final request6 = await contractDetailsRepositoryImpl.getDistrict(
            id: r.districtId ?? 1);
        request6.fold(
          (l) {},
          (r) => districtModel = r,
        );
        emit(ContractDetailsSuccess(
            model: r,
            profileModel: profileModel,
            workplaceModel: workplaceModel,
            doctorStatsModel: doctorStatsModel,
            outContractModel: outContractModel,
            districtModel: districtModel));
      },
    );
  }
}
