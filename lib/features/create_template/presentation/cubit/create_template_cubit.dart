import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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

  void getMedicine() async {
    emit(CreateTemplateGetMedicineLoading());
    final request = await createTemplateRepositoryImpl.getMedicine();
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
