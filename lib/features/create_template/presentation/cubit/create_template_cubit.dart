import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';

import '../../../../core/error/failure.dart';
import '../../../home/data/model/template_model.dart';
import '../../data/model/medicine_model.dart';
import '../../data/model/upload_template_model.dart';
import '../../data/repository/craete_template_repository_impl.dart';

part 'create_template_state.dart';

class CreateTemplateCubit extends Cubit<CreateTemplateState> {
  final CreateTemplateRepositoryImpl createTemplateRepositoryImpl;

  CreateTemplateCubit(this.createTemplateRepositoryImpl)
      : super(CreateTemplateInitial());

  void getMedicine({required List<MnnModel> inn}) async {
    List<String>? newInn = inn.map((e) => e.id.toString()).toList();
    print("----------------------------------------------------");
    print(newInn);
    
    emit(CreateTemplateGetMedicineLoading());
    final request = await createTemplateRepositoryImpl.getMedicine(inn: newInn);
    request.fold(
      (l) => emit(CreateTemplateGetMedicineError(failure: l)),
      (r) => emit(CreateTemplateGetMedicineSuccess(list: r)),
    );
  }

  void uploadTemplate({required UploadTemplateModel model}) async {
    emit(CreateTemplateUploadLoading());
    final request =
        await createTemplateRepositoryImpl.uploadTemplate(model: model);
    request.fold(
      (l) => emit(CreateTemplateUploadError(failure: l)),
      (r) => emit(CreateTemplateUploadSuccess()),
    );
  }
  void getMedicines({required List<MnnModel> inn}) async {
    List<String> newInn = inn
        .where((e) => e.id != null) // Filter out null IDs
        .map((e) => e.id!.toString())
        .toList();
    emit(CreateTemplateGetMedicineLoading());
    final request = await createTemplateRepositoryImpl.getMedicine(inn: newInn);
    request.fold(
          (l) => emit(CreateTemplateGetMedicineError(failure: l)),
          (r) => emit(CreateTemplateGetMedicineSuccess(list: r)),
    );
  }
  void updateTemplate({required TemplateModel model}) async {
    emit(UpdateTemplateUploadLoading());
    final request =
        await createTemplateRepositoryImpl.updateTemplate(model: model);
    request.fold(
      (l) => emit(UpdateTemplateUploadError(failure: l)),
      (r) => emit(UpdateTemplateUploadSuccess()),
    );
  }
}
