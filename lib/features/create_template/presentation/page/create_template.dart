import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import 'package:wm_doctor/features/create_template/data/model/upload_template_model.dart';
import 'package:wm_doctor/features/create_template/presentation/cubit/create_template_cubit.dart';
import 'package:wm_doctor/features/home/data/model/PreparationModel.dart';
import 'package:wm_doctor/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:wm_doctor/features/medicine/presentation/page/mnn_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/secure_storage.dart';
import '../../../../core/widgets/export.dart';
import '../../../../core/widgets/number_picker.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../home/data/model/template_model.dart';
import '../../../medicine/presentation/page/medicine_dialog.dart';

class PreparationContainerData {
  List<MnnModel> selectedMNNs;
  PreparationModel preparation;
  List<PreparationModel> selectedPreparations;
  List<MedicineModel> medicineList;
  PreparationContainerData({
    List<MnnModel>? selectedMNNs,
    PreparationModel? preparation,
    List<PreparationModel>? selectedPreparations,
    List<MedicineModel>? medicineList,
  })  : selectedMNNs = selectedMNNs ?? [],
        preparation = preparation ?? PreparationModel(name: '', amount: '', quantity: 0, timesInDay: 0, days: 0, type: '', medicineId: 0),
        selectedPreparations = selectedPreparations ?? [],
        medicineList = medicineList ?? [];

  PreparationContainerData copyWith({
    List<MnnModel>? selectedMNNs,
    PreparationModel? preparation,
    List<PreparationModel>? selectedPreparations,
    List<MedicineModel>? medicineList,
  }) {
    return PreparationContainerData(
      selectedMNNs: selectedMNNs ?? this.selectedMNNs,
      preparation: preparation ?? this.preparation,
      selectedPreparations: selectedPreparations ?? this.selectedPreparations,
      medicineList: medicineList ?? this.medicineList,
    );
  }
}

class CreateTemplate extends StatefulWidget {
  final TemplateModel? model;

  const CreateTemplate({super.key, this.model});

  @override
  State<CreateTemplate> createState() => _CreateTemplateState();
}

class _CreateTemplateState extends State<CreateTemplate> {
  final textController = TextEditingController();
  final diagnosisController = TextEditingController();
  final noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Widget> preparationContainers = [];
  List<MedicineModel> medicineList = [];
  List<PreparationContainerData> preparationContainersData = [];
  int lastAddIndex = -1;
  String templateName = "";
  final diagnosis = TextEditingController();
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  final commentController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    print("---------------s---------------------------------");
    context.read<CreateTemplateCubit>().getMedicine(inn: []);
    context.read<MedicineCubit>().getMedicine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTemplateCubit, CreateTemplateState>(
      listener: (context, state) {
        if (state is CreateTemplateUploadSuccess) {
          setState(() {
            templateName = "";
            diagnosis.text = "";
            numberController.text = "";
            nameController.text = "";
            birthDateController.text = "";
            commentController.text = "";
            selectedDate = null;
            medicineList.clear();
            preparationContainersData.clear();
            preparationContainers.clear();
          });
        }
        if (state is CreateTemplateUploadError) {
          toastification.show(
            style: ToastificationStyle.flat,
            context: context,
            alignment: Alignment.topCenter,
            title: Text(state.failure.errorMsg),
            autoCloseDuration: const Duration(seconds: 2),
            showProgressBar: false,
            primaryColor: Colors.white,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          );
        } else if (state is CreateTemplateGetMedicineError) {
          toastification.show(
            style: ToastificationStyle.flat,
            context: context,
            alignment: Alignment.topCenter,
            title: Text(state.failure.errorMsg),
            autoCloseDuration: const Duration(seconds: 2),
            showProgressBar: false,
            primaryColor: Colors.white,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          );
        } else if (state is CreateTemplateGetMedicineSuccess) {
          setState(() {
            print("Received medicines: ${state.list}");
            medicineList = state.list;
            print("Widget medicineList updated: $medicineList");
            if (lastAddIndex >= 0 && lastAddIndex < preparationContainersData.length) {
              preparationContainersData[lastAddIndex] = preparationContainersData[lastAddIndex].copyWith(
                medicineList: state.list,
              );
              preparationContainers[lastAddIndex] = buildPreparationContainer(lastAddIndex);
              print("Updated medicineList for container $lastAddIndex: ${preparationContainersData[lastAddIndex].medicineList}");
            }
          });
        }
      },
      builder: (context, state) {
        if (state is CreateTemplateUploadLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(
              widget.model != null
                  ? LocaleKeys.create_template_edit_template.tr()
                  : LocaleKeys.create_template_create_template.tr(),
              style:  TextStyle(
                fontFamily: 'VelaSans',
                fontSize: Dimens.space30,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  LocaleKeys.texts_back.tr(),
                  style:  TextStyle(
                    fontFamily: 'VelaSans',
                    fontWeight: FontWeight.w600,
                    fontSize: Dimens.space16,
                    color: AppColors.blueColor,
                  ),
                ),
              ).paddingOnly(right: Dimens.space20),
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                spacing: Dimens.space10,
                children: [
                  Container(
                    padding:  EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.space20),
                      color: AppColors.white,
                    ),
                    child: Column(
                      spacing: Dimens.space10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.create_template_title.tr(),
                          style:  TextStyle(
                            fontFamily: 'VelaSans',
                            fontSize: Dimens.space18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        AppTextField(
                          controller: textController,
                          hintText: LocaleKeys.create_template_write_here.tr(),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return LocaleKeys.create_template_fill_the_blanks.tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:  EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.space20),
                      color: AppColors.white,
                    ),
                    child: Column(
                      spacing: Dimens.space10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.create_template_diagnosis.tr(),
                          style:  TextStyle(
                            fontFamily: 'VelaSans',
                            fontSize: Dimens.space18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        AppTextField(
                          controller: diagnosisController,
                          hintText: LocaleKeys.create_template_write_here.tr(),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return LocaleKeys.create_template_fill_the_blanks.tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(children: preparationContainers),
                  UniversalButton.filled(
                    onPressed: addPreparationContainer,
                    cornerRadius: Dimens.space20,
                    backgroundColor: AppColors.blueAccent20,
                    text: LocaleKeys.create_recep_add_preparations.tr(),
                    textColor: AppColors.blueColor,
                  ),
                  Container(
                    padding:  EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.space20),
                      color: AppColors.white,
                    ),
                    child: Column(
                      spacing: Dimens.space10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.create_template_note.tr(),
                          style:  TextStyle(
                            fontFamily: 'VelaSans',
                            fontSize: Dimens.space18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        AppTextField(
                          controller: noteController,
                          hintText: LocaleKeys.create_template_write_here.tr(),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return LocaleKeys.create_template_fill_the_blanks.tr();
                            }
                            return null;
                          },
                          maxLines: 3,
                          minLines: 3,
                        ),
                      ],
                    ),
                  ),
                  UniversalButton.filled(
                    text: LocaleKeys.create_template_save_template.tr(),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (preparationContainersData.every((e) => e.preparation.name.isEmpty)) {
                          toastification.show(
                            style: ToastificationStyle.flat,
                            context: context,
                            alignment: Alignment.topCenter,
                            title: const Text(LocaleKeys.texts_add_medicine),
                            autoCloseDuration: const Duration(seconds: 2),
                            showProgressBar: false,
                            primaryColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          );
                        } else {
                          String token = await SecureStorage().read(key: "accessToken") ?? "";
                          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
                          String uuid = decodedToken["sub"];

                          List<Preparation> validPreparations = preparationContainersData
                              .where((e) => e.preparation.name.isNotEmpty)
                              .map((e) => Preparation(
                            name: e.preparation.name,
                            amount: e.preparation.amount,
                            quantity: e.preparation.quantity,
                            timesInDay: e.preparation.timesInDay,
                            days: e.preparation.days,
                            type: e.preparation.type,
                            medicineId: e.preparation.medicineId,
                            medicine: MedicineModel(id: e.preparation.medicineId),
                          ))
                              .toList();

                          if (widget.model != null) {
                            context.read<CreateTemplateCubit>().updateTemplate(
                              model: TemplateModel(
                                id: widget.model?.id ?? 0,
                                name: textController.text.trim(),
                                diagnosis: diagnosisController.text.trim(),
                                preparations: validPreparations
                                    .map((p) => TemplatePreparation(
                                  days: p.days,
                                  type: p.type,
                                  name: p.name,
                                  amount: p.amount,
                                  medicineId: p.medicineId,
                                  quantity: p.quantity,
                                  timesInDay: p.timesInDay,
                                ))
                                    .toList(),
                                note: noteController.text.trim(),
                                doctorId: uuid,
                                saved: widget.model?.saved ?? false,
                              ),
                            );
                          } else {
                            context.read<CreateTemplateCubit>().uploadTemplate(
                              model: UploadTemplateModel(
                                name: textController.text.trim(),
                                diagnosis: diagnosisController.text.trim(),
                                preparations: validPreparations,
                                note: noteController.text.trim(),
                                saved: false,
                                doctorId: uuid,
                              ),
                            );
                            toastification.show(
                              style: ToastificationStyle.flat,
                              context: context,
                              alignment: Alignment.topCenter,
                              title: Text(LocaleKeys.create_template_template_created.tr()),
                              autoCloseDuration: const Duration(seconds: 2),
                              showProgressBar: false,
                              primaryColor: Colors.white,
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            );
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                    fontSize: Dimens.space14,
                    backgroundColor: AppColors.blueColor,
                    cornerRadius: Dimens.space20,
                  ),
                   SizedBox(height: Dimens.space20),
                ],
              ).paddingSymmetric(horizontal: Dimens.space20),
            ),
          ),
        );
      },
    );
  }

  void addPreparationContainer() {
    setState(() {
      PreparationContainerData newData = PreparationContainerData(
        preparation: PreparationModel(
          name: "",
          amount: "",
          quantity: 0,
          timesInDay: 0,
          days: 0,
          type: "",
          medicineId: 0,
        ),
      );
      preparationContainersData.add(newData);
      preparationContainers.add(buildPreparationContainer(preparationContainersData.length - 1));
    });
  }

  Widget buildPreparationContainer(int index) {
    if (index >= preparationContainersData.length) {
      return const Text(
        "Index error",
        style: TextStyle(color: Colors.red),
      );
    }

    PreparationContainerData containerData = preparationContainersData[index];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding:  EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.create_recep_select.tr(),
                style:  TextStyle(
                  fontFamily: 'VelaSans',
                  fontWeight: FontWeight.w700,
                  fontSize: Dimens.space18,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    preparationContainersData.removeAt(index);
                    preparationContainers.removeAt(index);
                  });
                },
                child: SvgPicture.asset(
                  "assets/icons/minus.svg",
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.space10,
            children: [
               SizedBox(height: 5),
              UniversalButton.filled(
                text: LocaleKeys.create_recep_select_mnn.tr(),
                onPressed: () => showMNN(
                  ctx: context,
                  model: (value) {
                    if (mounted) {
                      setState(() {});
                    }
                    Navigator.pop(context);
                  },
                  mnn: [],
                  initialSelectedItems: containerData.selectedMNNs,
                  onSelectionComplete: (updatedList) async {
                    if (mounted) {
                      print("Setting lastAddIndex to $index");
                      lastAddIndex = index;
                      context.read<CreateTemplateCubit>().getMedicine(inn: updatedList);
                      setState(() {
                        containerData.selectedMNNs = updatedList;
                        preparationContainers[index] = buildPreparationContainer(index);
                      });
                    }
                  },
                ),
                fontSize: Dimens.space14,
                backgroundColor: AppColors.backgroundColor,
                textColor: Colors.black,
                cornerRadius: Dimens.space10,
              ),
              containerData.selectedMNNs.isNotEmpty
                  ? Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: containerData.selectedMNNs
                    .map((mnn) => Chip(
                  label: Text(
                    mnn.name ?? "null",
                    style: const TextStyle(color: Colors.black),
                  ),
                  deleteIcon: const Icon(Icons.remove_circle),
                  deleteIconColor: AppColors.redAccent,
                  backgroundColor: AppColors.backgroundColor,
                  side: BorderSide.none,
                  onDeleted: () {
                    setState(() {
                      containerData.selectedMNNs.remove(mnn);
                      preparationContainers[index] = buildPreparationContainer(index);
                    });
                  },
                ))
                    .toList(),
              )
                  : const SizedBox.shrink(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:  EdgeInsets.symmetric(
                  horizontal: Dimens.space20,
                  vertical: Dimens.space16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        containerData.selectedPreparations.isNotEmpty
                            ? containerData.selectedPreparations.first.name
                            : LocaleKeys.create_recep_select_medicine.tr(),
                        style:  TextStyle(
                          fontFamily: 'VelaSans',
                          fontSize: Dimens.space14,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Tapped Select Medicine for index: $index");
                        print("Container medicineList: ${containerData.medicineList}");
                        print("medicineList: ${medicineList.first.name}");

                          if (medicineList.isEmpty) {
                            print("Warning: Medicine list is empty for index $index");
                            toastification.show(
                              style: ToastificationStyle.flat,
                              context: context,
                              alignment: Alignment.topCenter,
                              title: const Text("No medicines available to select"),
                              autoCloseDuration: const Duration(seconds: 2),
                              showProgressBar: false,
                              primaryColor: Colors.white,
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            );
                            return;
                          }
                          try {
                            showMedicine(
                              ctx: context,
                              model: (value) {
                                if (value != null) {
                                  setState(() {
                                    containerData = containerData.copyWith(
                                      preparation: PreparationModel(
                                        name: value.name ?? "Unknown",
                                        amount: "${value.prescription ?? ''} ${value.volume ?? ''}".trim(),
                                        quantity: 1,
                                        timesInDay: 1,
                                        days: 1,
                                        inn: value.inn,
                                        type: value.type ?? "Unknown",
                                        medicineId: value.id ?? 0,
                                      ),
                                      selectedPreparations: [
                                        PreparationModel(
                                          name: value.name ?? "Unknown",
                                          amount: "${value.prescription ?? ''} ${value.volume ?? ''}".trim(),
                                          quantity: 1,
                                          timesInDay: 1,
                                          days: 1,
                                          inn: value.inn,
                                          type: value.type ?? "Unknown",
                                          medicineId: value.id ?? 0,
                                        ),
                                      ],
                                    );
                                    preparationContainersData[index] = containerData;
                                    preparationContainers[index] = buildPreparationContainer(index);
                                  });
                                }
                                Navigator.pop(context);
                              },
                              medicine: medicineList,
                            );
                          } catch (e) {
                            print("Error showing medicine dialog: $e");
                            toastification.show(
                              style: ToastificationStyle.flat,
                              context: context,
                              alignment: Alignment.topCenter,
                              title: const Text("Error displaying medicines"),
                              autoCloseDuration: const Duration(seconds: 2),
                              showProgressBar: false,
                              primaryColor: Colors.white,
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            );
                          }
                        },
                      child: SvgPicture.asset(
                        containerData.selectedPreparations.isEmpty
                            ? "assets/icons/plus.svg"
                            : "assets/icons/minus.svg",
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ...containerData.selectedPreparations.map((med) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                med.type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showInputAmount(
                                name: med.name,
                                amount: double.tryParse(med.amount) ?? 1.0,
                                onChange: (value) {
                                  setState(() {
                                    med.amount = value.toString();
                                    preparationContainers[index] = buildPreparationContainer(index);
                                  });
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    med.amount,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoNumberPicker(
                            selectedNumber: med.quantity,
                            onChanged: (int value) {
                              setState(() {
                                med.quantity = value;
                                preparationContainers[index] = buildPreparationContainer(index);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CupertinoNumberPicker(
                            selectedNumber: med.timesInDay,
                            onChanged: (int value) {
                              setState(() {
                                med.timesInDay = value;
                                preparationContainers[index] = buildPreparationContainer(index);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CupertinoNumberPicker(
                            selectedNumber: med.days,
                            onChanged: (int value) {
                              setState(() {
                                med.days = value;
                                preparationContainers[index] = buildPreparationContainer(index);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: Dimens.space10,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              LocaleKeys.create_recep_quantity.tr(),
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimens.space12,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              LocaleKeys.create_recep_times.tr(),
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimens.space12,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              LocaleKeys.create_recep_days.tr(),
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimens.space12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void showMedicine({
    required BuildContext ctx,
    required Function(MedicineModel?) model,
    required List<MedicineModel> medicine,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: ctx,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Medicine",
                  style:  TextStyle(
                    fontFamily: 'VelaSans',
                    fontSize: Dimens.space18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (medicine.isEmpty)
                  Padding(
                    padding:  EdgeInsets.all(Dimens.space20),
                    child: Text(
                      "No medicines available",
                      style:  TextStyle(
                        fontFamily: 'VelaSans',
                        fontSize: Dimens.space16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  ...medicine.map((med) => ListTile(
                    title: Text(
                      med.name ?? "Unknown",
                      style:  TextStyle(
                        fontFamily: 'VelaSans',
                        fontSize: Dimens.space16,
                      ),
                    ),
                    subtitle: Text(
                      "${med.prescription ?? ''} ${med.volume ?? ''}".trim(),
                      style:  TextStyle(
                        fontFamily: 'VelaSans',
                        fontSize: Dimens.space14,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      model(med);
                    },
                  )),
                 SizedBox(height: Dimens.space20),
              ],
            ).paddingOnly(
              left: Dimens.space20,
              right: Dimens.space20,
              top: Dimens.space20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
          ),
        );
      },
    );
  }

  void showInputAmount({
    required String name,
    required double amount,
    required ValueChanged<double> onChange,
  }) async {
    final textController = TextEditingController();
    final quantForm = GlobalKey<FormState>();
    textController.text = amount.toString();
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Form(
          key: quantForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.space20,
            children: [
              Text(
                name,
                style:  TextStyle(
                  fontSize: Dimens.space18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "kamida 1 ta bo'lishi kerak";
                  }
                  double? number = double.tryParse(value!);
                  if (number == null || number < 1) {
                    return "0 bo'lmasligi kerak";
                  }
                  return null;
                },
                maxLength: 5,
                controller: textController,
                decoration: const InputDecoration(hintText: "1"),
              ),
              UniversalButton.filled(
                text: "Сохранить",
                onPressed: () {
                  if (quantForm.currentState!.validate()) {
                    double number = double.parse(textController.text.trim());
                    onChange(number);
                    Navigator.pop(context);
                  }
                },
              ),
               SizedBox(height: Dimens.space50),
            ],
          ).paddingOnly(
            left: Dimens.space30,
            right: Dimens.space30,
            top: Dimens.space20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
        );
      },
    );
  }

  void showMedicineTypeList({required ValueChanged<String> onChange}) {
    List<String> types = ["PILLS", "TYPE2", "TYPE3"];
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                types.length,
                    (index) => ListTile(
                  onTap: () {
                    onChange(types[index]);
                    Navigator.pop(context);
                  },
                  title: Text(types[index]),
                ),
              ),
            ).paddingOnly(bottom: Dimens.space20),
          ),
        );
      },
      context: context,
    );
  }

  void removePreparationContainer() {
    setState(() {
      if (preparationContainers.isNotEmpty) {
        preparationContainers.removeAt(preparationContainers.length - 1);
        if (preparationContainersData.isNotEmpty) {
          preparationContainersData.removeAt(preparationContainersData.length - 1);
        }
      }
    });
  }
}