import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/repository/add_doctor_repository_impl.dart';

import '../../data/model/add_contract_model.dart';
import '../../data/model/doctor_model.dart';

part 'add_doctor_state.dart';

class AddDoctorCubit extends Cubit<AddDoctorState> {
  final AddDoctorRepositoryImpl addDoctorRepositoryImpl;

  AddDoctorCubit(this.addDoctorRepositoryImpl) : super(AddDoctorInitial());

  void addDoctor(
      {required DoctorModel doctor, required AddContractModel contract, required bool isCreateDoctor, required String doctorId}) async {
    emit(AddDoctorLoading());
    print('doctor = $doctor');
    if(isCreateDoctor){
      print('--------------------------  contract and doctor create');
      final checkNumber =
      await addDoctorRepositoryImpl.checkNumber(number: doctor.number);
      checkNumber.fold(
            (l) => emit(AddDoctorError(failure: l)),
            (r) async {
          if (r) {
            emit(AddDoctorError(
                failure: Failure(errorMsg: "Bu raqam mavjud", statusCode: 500)));
          } else {
            final checkEmail = await addDoctorRepositoryImpl.checkEmail(
                email: doctor.email);
            checkEmail.fold(
                  (l) => emit(AddDoctorError(failure: l)),
                  (r) async {
                if (r) {
                  emit(AddDoctorError(
                      failure:
                      Failure(errorMsg: "Bu email mavjud", statusCode: 500)));
                }
                final registerDoctor =
                await addDoctorRepositoryImpl.addDoctor(model: doctor);
                registerDoctor.fold(
                      (l) => emit(AddDoctorError(failure: l)),
                      (r) async {
                    final addContract = await addDoctorRepositoryImpl.addContract(
                        model: contract, doctorId: r);
                    addContract.fold(
                          (l) => emit(AddDoctorError(failure: l)),
                          (r) => emit(AddDoctorSuccess()),
                    );
                  },
                );
              },
            );
          }
        },
      );
    }else {
      print("---------------------------------------------------------------doctorId = $doctorId");
      print('--------------------------  contract create');

      final addContract = await addDoctorRepositoryImpl.addContract(
          model: contract, doctorId: doctorId);
      addContract.fold(
            (l) => emit(AddDoctorError(failure: l)),
            (r) => emit(AddDoctorSuccess()),
      );
    }
  }
}
