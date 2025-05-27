import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/workplace_model.dart';
import 'package:wm_doctor/features/profile/data/model/user_model.dart';
import 'package:wm_doctor/features/profile/data/repository/profile_repository_impl.dart';
import 'package:wm_doctor/features/regions/data/model/district_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepositoryImpl profileRepositoryImpl;

  ProfileCubit(this.profileRepositoryImpl) : super(ProfileInitial());

  Future<void> getUserData() async {

    emit(ProfileLoading());

    final request = await profileRepositoryImpl.getUserData();
    request.fold(
          (l) => emit(ProfileError(failure: l)),
          (r) async {
        DistrictModel? districtModel;
        WorkplaceModel? workplaceModel;
        final district = await profileRepositoryImpl.getDistrict(id: r.districtId ?? 100);
        district.fold(
              (l) {},
              (r) {
            districtModel = r;
          },
        );
        final workplace = await profileRepositoryImpl.getWorkplace(id: r.workplaceId ?? 1);
        workplace.fold(
              (l) {},
              (r) {
            workplaceModel = r;
          },
        );
        emit(ProfileSuccess(
            model: r,
            districtModel: districtModel,
            workplaceModel: workplaceModel));
      },
    );
  }
}