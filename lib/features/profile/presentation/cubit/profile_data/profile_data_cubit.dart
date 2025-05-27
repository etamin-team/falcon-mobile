import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/profile/data/repository/profile_repository_impl.dart';
import '../../../data/model/profile_data_model.dart';

part 'profile_data_state.dart';

class ProfileDataCubit extends Cubit<ProfileDataState> {
  final ProfileRepositoryImpl profileRepositoryImpl;

  ProfileDataCubit(this.profileRepositoryImpl) : super(ProfileDataInitial());

  Future<void> getProfileData() async {
    emit(ProfileDataLoading());
    final request = await profileRepositoryImpl.getProfileData();
    request.fold(
          (l) => emit(ProfileDataError(failure: l)),
          (r) => emit(ProfileDataSuccess(model: r)),
    );
  }
}