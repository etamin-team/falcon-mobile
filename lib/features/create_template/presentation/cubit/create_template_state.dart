part of 'create_template_cubit.dart';

sealed class CreateTemplateState extends Equatable {
  const CreateTemplateState();
}

final class CreateTemplateInitial extends CreateTemplateState {
  @override
  List<Object> get props => [];
}

final class CreateTemplateGetMedicineLoading extends CreateTemplateState {
  @override
  List<Object> get props => [];
}

final class CreateTemplateGetMedicineSuccess extends CreateTemplateState {
  final List<MedicineModel> list;

  const CreateTemplateGetMedicineSuccess({required this.list});

  @override
  List<Object> get props => [list];
}

final class CreateTemplateGetMedicineError extends CreateTemplateState {
  final Failure failure;

  const CreateTemplateGetMedicineError({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class CreateTemplateUploadLoading extends CreateTemplateState {
  @override
  List<Object> get props => [];
}

final class CreateTemplateUploadSuccess extends CreateTemplateState {
  @override
  List<Object> get props => [];
}

final class CreateTemplateUploadError extends CreateTemplateState {
  final Failure failure;

  const CreateTemplateUploadError({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class UpdateTemplateUploadLoading extends CreateTemplateState {
  @override
  List<Object> get props => [];
}

final class UpdateTemplateUploadSuccess extends CreateTemplateState {
  @override
  List<Object> get props => [];
}

final class UpdateTemplateUploadError extends CreateTemplateState {
  final Failure failure;

  const UpdateTemplateUploadError({required this.failure});

  @override
  List<Object> get props => [failure];
}
