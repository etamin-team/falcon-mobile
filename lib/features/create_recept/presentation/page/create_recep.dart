import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/services/secure_storage.dart';
import 'package:wm_doctor/core/utils/text_mask.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/core/widgets/number_picker.dart';
import 'package:wm_doctor/features/create_recept/data/model/recep_model.dart';
import 'package:wm_doctor/features/create_recept/presentation/cubit/create_recep_cubit.dart';
import 'package:wm_doctor/features/create_recept/presentation/page/receipt_success.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import 'package:wm_doctor/features/create_template/presentation/cubit/create_template_cubit.dart';
import 'package:wm_doctor/features/home/data/model/PreparationModel.dart';
import 'package:wm_doctor/features/home/data/model/template_model.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_dialog.dart';
import 'package:wm_doctor/features/medicine/presentation/page/mnn_dialog.dart';
import 'package:wm_doctor/features/template/presentation/page/templates.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../create_template/data/model/upload_template_model.dart';


class PrepContainerData {
  List<MnnModel> selectedMNNs;
  PreparationModel preparation;
  List<PreparationModel> selectedPreparations;
  List<MedicineModel> medicineList;

  PrepContainerData({
    List<MnnModel>? selectedMNNs,
    PreparationModel? preparation,
    List<PreparationModel>? selectedPreparations,
    List<MedicineModel>? medicineList,
  })  : selectedMNNs = selectedMNNs ?? [],
        preparation = preparation ??
            PreparationModel(
                name: '',
                amount: '',
                quantity: 0,
                timesInDay: 0,
                days: 0,
                type: '',
                medicineId: 0),
        selectedPreparations = selectedPreparations ?? [],
        medicineList = medicineList ?? [];

  PrepContainerData copyWith({
    List<MnnModel>? selectedMNNs,
    PreparationModel? preparation,
    List<PreparationModel>? selectedPreparations,
    List<MedicineModel>? medicineList,
  }) {
    return PrepContainerData(
      selectedMNNs: selectedMNNs ?? this.selectedMNNs,
      preparation: preparation ?? this.preparation,
      selectedPreparations: selectedPreparations ?? this.selectedPreparations,
      medicineList: medicineList ?? this.medicineList,
    );
  }
}


class CreateRecep extends StatefulWidget {
  final List<MnnModel> selectedMNNs;

  CreateRecep(this.selectedMNNs, {super.key});

  @override
  State<CreateRecep> createState() => _CreateRecepState();
}

class _CreateRecepState extends State<CreateRecep> {
  final formKey = GlobalKey<FormState>();
  final diagnosisController = TextEditingController();
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  final commentController = TextEditingController();
  DateTime? selectedDate;
  String templateName = "";
  List<Widget> preparationContainers = [];
  List<PrepContainerData> preparationContainersData = [];
  List<TextEditingController> nameControllers = [];
  List<Timer?> debounceTimers = [];
  List<MedicineModel> medicineList = [];
  int lastAddIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<CreateTemplateCubit>().getMedicine(inn: widget.selectedMNNs);
    _addNewContainer(); // Initialize with one container
  }


  @override
  void dispose() {
    diagnosisController.dispose();
    numberController.dispose();
    nameController.dispose();
    birthDateController.dispose();
    commentController.dispose();
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var timer in debounceTimers) {
      timer?.cancel();
    }
    super.dispose();
  }

  void _addNewContainer() {
    setState(() {
      final newData = PrepContainerData();
      preparationContainersData.add(newData);
      nameControllers.add(TextEditingController());
      debounceTimers.add(null);
      final index = preparationContainersData.length - 1;
      preparationContainers.add(buildPreparationContainer(index));
      lastAddIndex = index;
    });
  }

  void addPreparationContainer() {
    setState(() {
      final newData = PrepContainerData(
        preparation: PreparationModel(
          name: "",
          amount: "",
          quantity: 0,
          timesInDay: 0,
          days: 0,
          type: "",
          medicineId: 0,
        ),
        medicineList: medicineList,
      );
      preparationContainersData.add(newData);
      nameControllers.add(TextEditingController());
      debounceTimers.add(null);
      final index = preparationContainersData.length - 1;
      preparationContainers.add(buildPreparationContainer(index));
      lastAddIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateRecepCubit, CreateRecepState>(
      listener: (context, state) {
        if (state is CreateRecepSuccess || state is SendTelegramSuccess) {
          setState(() {
            templateName = "";
            diagnosisController.clear();
            numberController.clear();
            nameController.clear();
            birthDateController.clear();
            commentController.clear();
            selectedDate = null;
            preparationContainersData.clear();
            preparationContainers.clear();
            nameControllers.clear();
            debounceTimers.clear();
            lastAddIndex = -1;
            _addNewContainer(); // Re-add initial container after success
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReceiptSuccessPage()),
          );
        } else if (state is CreateRecepError || state is SendTelegramError) {
          toastification.show(
            style: ToastificationStyle.flat,
            context: context,
            alignment: Alignment.topCenter,
            title: Text(state is CreateRecepError
                ? state.failure.errorMsg
                : 'Failed to send Telegram message'),
            autoCloseDuration: Duration(seconds: 4),
            showProgressBar: false,
            primaryColor: Colors.white,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        if (state is CreateRecepLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return BlocListener<CreateTemplateCubit, CreateTemplateState>(
          listener: (context, cstate) {
            if (cstate is CreateTemplateGetMedicineSuccess) {
              setState(() {
                medicineList = cstate.list;
                if (lastAddIndex >= 0 &&
                    lastAddIndex < preparationContainersData.length) {
                  preparationContainersData[lastAddIndex] =
                      preparationContainersData[lastAddIndex]
                          .copyWith(medicineList: cstate.list);
                  preparationContainers[lastAddIndex] =
                      buildPreparationContainer(lastAddIndex);
                }
              });
            } else if (cstate is CreateTemplateGetMedicineError) {
              toastification.show(
                style: ToastificationStyle.flat,
                context: context,
                alignment: Alignment.topCenter,
                title: Text(cstate.failure.errorMsg),
                autoCloseDuration: Duration(seconds: 2),
                showProgressBar: false,
                primaryColor: Colors.white,
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              );
            }
          },
          child: buildScaffold(context),
        );
      },
    );
  }


  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          LocaleKeys.create_recep_title.tr(),
          style: TextStyle(
            fontFamily: 'VelaSans',
            fontSize: Dimens.space30,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            spacing: Dimens.space10,
            children: [
              buildTemplateSelection(),
              buildNameField(),
              buildBirthDateAndNumberField(),
              buildDiagnosisField(),
              Column(children: preparationContainers),
              UniversalButton.filled(
                onPressed: addPreparationContainer,
                cornerRadius: Dimens.space20,
                backgroundColor: AppColors.blueAccent20,
                text: LocaleKeys.create_recep_add_preparations.tr(),
                textColor: AppColors.blueColor,
              ),
              buildCommentField(),
              UniversalButton.filled(
                text: LocaleKeys.create_recep_send_recep.tr(),
                onPressed: createRecep,
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
  }

  Widget buildTemplateSelection() {
    return Container(
      padding: EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.space20),
        color: AppColors.white,
      ),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            showDragHandle: true,
            enableDrag: true,
            useSafeArea: true,
            isScrollControlled: true,
            backgroundColor: AppColors.backgroundColor,
            context: context,
            builder: (context) {
              return TemplatePage(
                isBottom: true,
                onChange: (TemplateModel value) {
                  setState(() {
                    templateName = value.name ?? "";
                    preparationContainersData = List.generate(
                      value.preparations?.length ?? 0,
                          (index) => PrepContainerData(
                        selectedMNNs: widget.selectedMNNs,
                        medicineList: medicineList,
                        preparation: PreparationModel(
                          name: value.preparations![index].name ?? "",
                          amount: value.preparations![index].amount.toString(),
                          medicineId: value.preparations![index].medicineId ?? 0,
                          days: value.preparations![index].days ?? 0,
                          timesInDay: value.preparations![index].timesInDay ?? 0,
                          quantity: value.preparations![index].quantity ?? 0,
                          type: value.preparations![index].type ?? "",
                        ),
                        selectedPreparations: [
                          PreparationModel(
                            name: value.preparations![index].name ?? "",
                            amount: value.preparations![index].amount.toString(),
                            medicineId:
                            value.preparations![index].medicineId ?? 0,
                            days: value.preparations![index].days ?? 0,
                            timesInDay:
                            value.preparations![index].timesInDay ?? 0,
                            quantity: value.preparations![index].quantity ?? 0,
                            type: value.preparations![index].type ?? "",
                          ),
                        ],
                      ),
                    );
                    nameControllers = List.generate(
                      value.preparations?.length ?? 0,
                          (index) => TextEditingController(
                          text: value.preparations![index].name ?? ""),
                    );
                    debounceTimers = List.generate(
                      value.preparations?.length ?? 0,
                          (index) => null,
                    );
                    preparationContainers = List.generate(
                      value.preparations?.length ?? 0,
                          (index) => buildPreparationContainer(index),
                    );
                    diagnosisController.text = value.diagnosis ?? "";
                    commentController.text = value.note ?? "";
                    lastAddIndex = preparationContainersData.isEmpty
                        ? -1
                        : preparationContainersData.length - 1;
                    if (kDebugMode) {
                      print("Template imported: ${value.name}");
                    }
                  });
                },
              );
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.space14, vertical: Dimens.space16),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(Dimens.space10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  templateName.isEmpty
                      ? LocaleKeys.create_recep_select_template.tr()
                      : templateName,
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                    fontSize: Dimens.space14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(CupertinoIcons.chevron_down),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Container(
      padding: EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.space20),
        color: AppColors.white,
      ),
      child: Column(
        spacing: Dimens.space10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.create_recep_name.tr(),
            style: TextStyle(
              fontFamily: 'VelaSans',
              fontSize: Dimens.space18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          AppTextField(
            controller: nameController,
            hintText: LocaleKeys.create_recep_name.tr(),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return LocaleKeys.create_recep_enter_name.tr();
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildBirthDateAndNumberField() {
    return Container(
      padding: EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.space20),
        color: AppColors.white,
      ),
      child: Column(
        spacing: Dimens.space10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.create_recep_birthdate_and_number.tr(),
            style: TextStyle(
              fontFamily: 'VelaSans',
              fontSize: Dimens.space18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () => showDatePickerBottomSheet(context),
            child: AppTextField(
              textColor: Colors.black,
              isEnabled: false,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return LocaleKeys.sign_up_enter_middleName.tr();
                }
                return null;
              },
              keyboardType: TextInputType.datetime,
              formatter: [
                TextMask(pallet: '##/##/####'),
                LengthLimitingTextInputFormatter(10),
              ],
              suffixIcon: InkWell(
                child: SvgPicture.asset(
                  Assets.icons.calendar,
                  height: Dimens.space14,
                  width: Dimens.space14,
                ).paddingAll(value: Dimens.space10),
              ),
              controller: birthDateController,
              hintText: "29/11/2001",
            ),
          ),
          AppTextField(
            prefixIcon: Text(
              textAlign: TextAlign.center,
              "+998  ",
              style: TextStyle(fontFamily: 'VelaSans', color: Colors.black),
            ),
            validator: (value) {
              if (value?.length != 12) {
                return LocaleKeys.create_recep_enter_number.tr();
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            formatter: [
              TextMask(pallet: '## ### ## ##'),
              FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9\s]*$')),
              LengthLimitingTextInputFormatter(12),
            ],
            controller: numberController,
            hintText: "90 123 45 67",
          ),
        ],
      ),
    );
  }

  Widget buildDiagnosisField() {
    return Container(
      padding: EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.space20),
        color: AppColors.white,
      ),
      child: Column(
        spacing: Dimens.space10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.create_recep_diagnose.tr(),
            style: TextStyle(
              fontFamily: 'VelaSans',
              fontSize: Dimens.space18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          AppTextField(
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return LocaleKeys.create_recep_enter_diagnose.tr();
              }
              return null;
            },
            controller: diagnosisController,
            hintText: LocaleKeys.create_recep_write_here.tr(),
          ),
        ],
      ),
    );
  }

  Widget buildCommentField() {
    return Container(
      padding: EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.space20),
        color: AppColors.white,
      ),
      child: Column(
        spacing: Dimens.space10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.create_recep_add_comment.tr(),
            style: TextStyle(
              fontFamily: 'VelaSans',
              fontSize: Dimens.space18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          AppTextField(
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return LocaleKeys.create_recep_enter_comment.tr();
              }
              return null;
            },
            controller: commentController,
            hintText: LocaleKeys.create_recep_write_here.tr(),
            maxLines: 3,
            minLines: 3,
          ),
        ],
      ),
    );
  }

  Widget buildPreparationContainer(int index) {
    if (index >= preparationContainersData.length ||
        index >= nameControllers.length ||
        index >= debounceTimers.length) {
      return Text(
        "Index error",
        style: TextStyle(color: Colors.red),
      );
    }

    PrepContainerData containerData = preparationContainersData[index];
    PreparationModel med = containerData.preparation;
    TextEditingController nameController = nameControllers[index];

    // Sync controller text with preparation name
    if (nameController.text != (containerData.selectedPreparations.isNotEmpty
        ? containerData.selectedPreparations.first.name
        : '')) {
      nameController.text = containerData.selectedPreparations.isNotEmpty
          ? containerData.selectedPreparations.first.name
          : '';
    }

    // Automatically select the first medicine if available and none selected
    if (containerData.medicineList.isNotEmpty &&
        containerData.selectedPreparations.isEmpty &&
        lastAddIndex == index) {
      final firstMedicine = containerData.medicineList.first;
      containerData = containerData.copyWith(
        preparation: PreparationModel(
          name: firstMedicine.name ?? "Unknown",
          amount:
          "${firstMedicine.prescription ?? ''} ${firstMedicine.volume ?? ''}"
              .trim(),
          quantity: 1,
          timesInDay: 1,
          days: 1,
          inn: firstMedicine.inn,
          type: firstMedicine.type ?? "Unknown",
          medicineId: firstMedicine.id ?? 0,
        ),
        selectedPreparations: [
          PreparationModel(
            name: firstMedicine.name ?? "Unknown",
            amount:
            "${firstMedicine.prescription ?? ''} ${firstMedicine.volume ?? ''}"
                .trim(),
            quantity: 1,
            timesInDay: 1,
            days: 1,
            inn: firstMedicine.inn,
            type: firstMedicine.type ?? "Unknown",
            medicineId: firstMedicine.id ?? 0,
          ),
        ],
      );
      preparationContainersData[index] = containerData;
      nameController.text = firstMedicine.name ?? "Unknown";
      preparationContainers[index] = buildPreparationContainer(index);
    }

    return Container(
      key: ValueKey('prep_container_$index'),
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(Dimens.space20),
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
                style: TextStyle(
                  fontFamily: 'VelaSans',
                  fontWeight: FontWeight.w700,
                  fontSize: Dimens.space18,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (preparationContainersData.length > 1) {
                      preparationContainersData.removeAt(index);
                      preparationContainers.removeAt(index);
                      nameControllers.removeAt(index);
                      debounceTimers[index]?.cancel();
                      debounceTimers.removeAt(index);
                      // Rebuild all containers to ensure correct indexing
                      preparationContainers = List.generate(
                        preparationContainersData.length,
                            (i) => buildPreparationContainer(i),
                      );
                      // Adjust lastAddIndex
                      if (lastAddIndex == index) {
                        lastAddIndex = preparationContainersData.isEmpty
                            ? -1
                            : preparationContainersData.length - 1;
                      } else if (lastAddIndex > index) {
                        lastAddIndex--;
                      }
                    } else {
                      // Prevent deletion of the last container
                      toastification.show(
                        style: ToastificationStyle.flat,
                        context: context,
                        alignment: Alignment.topCenter,
                        title: Text("At least one preparation is required"),
                        autoCloseDuration: Duration(seconds: 2),
                        showProgressBar: false,
                        primaryColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      );
                    }
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
            children: [
              SizedBox(height: 5),
              UniversalButton.filled(
                text: LocaleKeys.create_recep_select_mnn.tr(),
                onPressed: () => showMNN(
                  ctx: context,
                  model: (value) {},
                  mnn: [],
                  initialSelectedItems: containerData.selectedMNNs,
                  onSelectionComplete: (updatedList) async {
                    lastAddIndex = index;
                    setState(() {
                      containerData = containerData.copyWith(
                        selectedMNNs: updatedList,
                        medicineList: [],
                        selectedPreparations: [],
                        preparation: PreparationModel(
                          name: '',
                          amount: '',
                          quantity: 1,
                          timesInDay: 1,
                          days: 1,
                          inn: null,
                          type: '',
                          medicineId: 0,
                        ),
                      );
                      preparationContainersData[index] = containerData;
                      nameController.clear();
                      preparationContainers[index] =
                          buildPreparationContainer(index);
                      context
                          .read<CreateTemplateCubit>()
                          .getMedicine(inn: updatedList);
                    });
                  },
                ),
                fontSize: Dimens.space14,
                backgroundColor: AppColors.backgroundColor,
                textColor: Colors.black,
                cornerRadius: Dimens.space10,
              ),
              if (containerData.selectedMNNs.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: containerData.selectedMNNs
                      .map((mnn) => Chip(
                    label: Text(
                      mnn.name ?? "null",
                      style: TextStyle(color: Colors.black),
                    ),
                    deleteIcon: Icon(Icons.remove_circle),
                    deleteIconColor: AppColors.redAccent,
                    backgroundColor: AppColors.backgroundColor,
                    side: BorderSide.none,
                    onDeleted: () {
                      setState(() {
                        containerData = containerData.copyWith(
                          selectedMNNs: containerData.selectedMNNs
                              .where((item) => item != mnn)
                              .toList(),
                          medicineList: [],
                          selectedPreparations: [],
                        );
                        preparationContainersData[index] = containerData;
                        nameController.clear();
                        preparationContainers[index] =
                            buildPreparationContainer(index);
                      });
                    },
                  ))
                      .toList(),
                ),
              SizedBox(height: 10),
              if (containerData.medicineList.isEmpty &&
                  containerData.selectedMNNs.isNotEmpty)
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_recep_select_medicine.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundColor,
                  ),
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    debounceTimers[index]?.cancel();
                    debounceTimers[index] =
                        Timer(Duration(milliseconds: 300), () {
                          setState(() {
                            final updatedMed = med.copyWith(name: value);
                            containerData = containerData.copyWith(
                              preparation: updatedMed,
                              selectedPreparations: [updatedMed],
                            );
                            preparationContainersData[index] = containerData;
                            preparationContainers[index] =
                                buildPreparationContainer(index);
                          });
                        });
                  },
                )
              else
                GestureDetector(
                  onTap: () {
                    if (containerData.medicineList.isEmpty &&
                        containerData.selectedMNNs.isEmpty) {
                      toastification.show(
                        style: ToastificationStyle.flat,
                        context: context,
                        alignment: Alignment.topCenter,
                        title: const Text("Please select MNNs first"),
                        autoCloseDuration: const Duration(seconds: 2),
                        showProgressBar: false,
                        primaryColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      );
                      return;
                    }
                    if (containerData.medicineList.isEmpty) {
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
                          setState(() {
                            containerData = containerData.copyWith(
                              preparation: PreparationModel(
                                name: value.name ?? "Unknown",
                                amount:
                                "${value.prescription ?? ''} ${value.volume ?? ''}"
                                    .trim(),
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
                                  amount:
                                  "${value.prescription ?? ''} ${value.volume ?? ''}"
                                      .trim(),
                                  quantity: 1,
                                  timesInDay: 1,
                                  days: 1,
                                  inn: value.inn,
                                  type: value.type ?? "Unknown",
                                  medicineId: value.id ?? 0,
                                ),
                              ],
                            );
                            nameController.text = value.name ?? "Unknown";
                            preparationContainersData[index] = containerData;
                            preparationContainers[index] =
                                buildPreparationContainer(index);
                          });
                          Navigator.pop(context);
                        },
                        medicine: containerData.medicineList,
                      );
                    } catch (e) {
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
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
                            style: TextStyle(
                              fontFamily: 'VelaSans',
                              fontSize: Dimens.space14,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        GestureDetector(
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
                ),
              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              med.type.isNotEmpty ? med.type : "Type",
                              style:
                              TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showInputAmount(
                              name: med.name.isNotEmpty ? med.name : "Amount",
                              amount: double.tryParse(med.amount) ?? 1.0,
                              onChange: (value) {
                                setState(() {
                                  final updatedMed =
                                  med.copyWith(amount: value.toString());
                                  containerData = containerData.copyWith(
                                    preparation: updatedMed,
                                    selectedPreparations:
                                    containerData.selectedPreparations.isNotEmpty
                                        ? [updatedMed]
                                        : [],
                                  );
                                  preparationContainersData[index] = containerData;
                                  preparationContainers[index] =
                                      buildPreparationContainer(index);
                                });
                              },
                            );
                          },
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  med.amount.isNotEmpty ? med.amount : "Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 12),
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
                              final updatedMed = med.copyWith(quantity: value);
                              containerData = containerData.copyWith(
                                preparation: updatedMed,
                                selectedPreparations:
                                containerData.selectedPreparations.isNotEmpty
                                    ? [updatedMed]
                                    : [],
                              );
                              preparationContainersData[index] = containerData;
                              preparationContainers[index] =
                                  buildPreparationContainer(index);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CupertinoNumberPicker(
                          selectedNumber: med.timesInDay,
                          onChanged: (int value) {
                            setState(() {
                              final updatedMed = med.copyWith(timesInDay: value);
                              containerData = containerData.copyWith(
                                preparation: updatedMed,
                                selectedPreparations:
                                containerData.selectedPreparations.isNotEmpty
                                    ? [updatedMed]
                                    : [],
                              );
                              preparationContainersData[index] = containerData;
                              preparationContainers[index] =
                                  buildPreparationContainer(index);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CupertinoNumberPicker(
                          selectedNumber: med.days,
                          onChanged: (int value) {
                            setState(() {
                              final updatedMed = med.copyWith(days: value);
                              containerData = containerData.copyWith(
                                preparation: updatedMed,
                                selectedPreparations:
                                containerData.selectedPreparations.isNotEmpty
                                    ? [updatedMed]
                                    : [],
                              );
                              preparationContainersData[index] = containerData;
                              preparationContainers[index] =
                                  buildPreparationContainer(index);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  void createRecep() async {
    if (formKey.currentState!.validate() &&
        preparationContainersData.isNotEmpty) {
      final token = await SecureStorage().read(key: "accessToken") ?? "";
      final decodedToken = JwtDecoder.decode(token);
      final docID = decodedToken["sub"];

      final validPreparations = preparationContainersData
          .where((e) => e.preparation.name.isNotEmpty && e.preparation.medicineId != 0)
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

      if (validPreparations.isEmpty) {
        toastification.show(
          style: ToastificationStyle.flat,
          context: context,
          alignment: Alignment.topCenter,
          title: Text(LocaleKeys.create_recep_add_medicine.tr()),
          autoCloseDuration: Duration(seconds: 2),
          showProgressBar: false,
          primaryColor: Colors.white,
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        );
        return;
      }
      context.read<CreateRecepCubit>().saveRecep(
        model: RecepModel(
          doctorId: docID,
          firstName: nameController.text.trim(),
          lastName: "",
          dateOfBirth: selectedDate ?? DateTime.now(),
          phoneNumber: numberController.text.trim().replaceAll(" ", ""),
          phoneNumberPrefix: "+998",
          dateCreation: DateTime.now(),
          diagnosis: diagnosisController.text.trim(),
          comment: commentController.text.trim(),
          telegramId: 0,
          districtId: 100,
          preparations: validPreparations,
        ),
      );

      final message = buildTelegramMessage();
      context.read<CreateRecepCubit>().sendTelegramData(
        number: "998${numberController.text.trim().replaceAll(" ", "")}",
        message: message,
      );
    } else {
      showValidationError();
    }
  }

  String buildTelegramMessage() {
    var message = '💊 Пациент: ${nameController.text.trim()}\n';

    // Add additional names from nameControllers (if any)
    if (nameControllers.isNotEmpty) {
      message += 'Дополнительные пациенты:\n';
      for (int i = 0; i < nameControllers.length; i++) {
        final additionalName = nameControllers[i].text.trim();
        if (additionalName.isNotEmpty) {
          message += '• ${additionalName}\n';
        }
      }
      message += '\n';
    }

    message += '\nДата рождения: ${birthDateController.text}\n\n'
        '🩺 Диагноз:\n${diagnosisController.text.trim()}\n\n'
        '📝 Рецепт:\n';

    var receiptDetails = '';
    for (var container in preparationContainersData) {
      if (container.selectedMNNs.isNotEmpty &&
          container.selectedPreparations.isNotEmpty) {
        for (var i = 0; i < container.selectedPreparations.length; i++) {
          final prep = container.selectedPreparations[i];
          final mnnName = container.selectedMNNs.length > i
              ? container.selectedMNNs[i].name
              : '';
          receiptDetails +=
          '✅ [$mnnName] ${prep.name} ${prep.amount} ${prep.quantity} ${prep.type} * ${prep.timesInDay} раз в день (${prep.days} дней)\n';
        }
      } else if (container.selectedPreparations.isNotEmpty) {
        for (var prep in container.selectedPreparations) {
          receiptDetails +=
          '✅ ${prep.name} ${prep.amount} ${prep.quantity} ${prep.type} * ${prep.timesInDay} раз в день (${prep.days} дней)\n';
        }
      } else if (container.selectedMNNs.isNotEmpty) {
        for (var mnn in container.selectedMNNs) {
          receiptDetails += '[${mnn.name}]\n';
        }
      }
    }

    message += receiptDetails.isNotEmpty
        ? receiptDetails
        : 'Hech qanday dori yoki MNN tanlanmagan\n';

    message += '\nПримечание: ${commentController.text.trim()}';
    return message;
  }


  void showValidationError() {
    String? errorMessage;
    if (nameController.text.isEmpty) {
      errorMessage = LocaleKeys.create_recep_enter_name.tr();
    } else if (birthDateController.text.isEmpty) {
      errorMessage = LocaleKeys.create_recep_enter_birthdate.tr();
    } else if (numberController.text.length != 12) {
      errorMessage = LocaleKeys.create_recep_enter_number.tr();
    } else if (preparationContainersData.isEmpty) {
      errorMessage = LocaleKeys.create_recep_add_medicine.tr();
    }

    if (errorMessage != null) {
      toastification.show(
        style: ToastificationStyle.flat,
        context: context,
        alignment: Alignment.topCenter,
        title: Text(errorMessage),
        autoCloseDuration: Duration(seconds: 4),
        showProgressBar: false,
        primaryColor: Colors.white,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      );
    }
  }

  Future<void> showDatePickerBottomSheet(BuildContext ctx) async {
    DateTime dateTime = DateTime.now();
    if (birthDateController.text.length == 10) {
      final format = DateFormat("dd/MM/yyyy");
      selectedDate = format.parse(birthDateController.text);
      dateTime = selectedDate!;
    }

    return showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                LocaleKeys.sign_up_select_date.tr(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime: selectedDate ?? DateTime.now(),
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    dateTime = newDate;
                  },
                ),
              ),
              CupertinoButton(
                child: Text(
                  LocaleKeys.sign_up_save.tr(),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = dateTime;
                    birthDateController.text =
                        DateFormat('dd/MM/yyyy').format(selectedDate!);
                  });
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void showInputAmount({
    required String name,
    required double amount,
    required ValueChanged<double> onChange,
  }) {
    final textController = TextEditingController(text: amount.toString());
    final quantForm = GlobalKey<FormState>();

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
                style: TextStyle(
                    fontSize: Dimens.space18, fontWeight: FontWeight.w500),
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "kamida 1 ta bo'lishi kerak";
                  }
                  final number = double.tryParse(value!);
                  if (number == null || number < 1) {
                    return "0 bo'lmasligi kerak";
                  }
                  return null;
                },
                maxLength: 5,
                controller: textController,
                decoration: InputDecoration(hintText: "1"),
              ),
              UniversalButton.filled(
                text: "Сохранить",
                onPressed: () {
                  if (quantForm.currentState!.validate()) {
                    final number = double.parse(textController.text.trim());
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
              bottom: MediaQuery.of(context).viewInsets.bottom),
        );
      },
    );
  }
}