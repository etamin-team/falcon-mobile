import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
              medicineId: 0,
            ),
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
    _addNewContainer();
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
      final newData = PrepContainerData(
        selectedMNNs: List.from(widget.selectedMNNs),
        medicineList: List.from(medicineList),
      );
      preparationContainersData.add(newData);
      nameControllers.add(TextEditingController());
      debounceTimers.add(null);
      final index = preparationContainersData.length - 1;
      preparationContainers.add(_buildPreparationContainer(index));
      lastAddIndex = index;
    });
  }

  void _updateTemplateData(TemplateModel value) {
    final newData = value.preparations?.isNotEmpty == true
        ? List<PrepContainerData>.generate(
      value.preparations!.length,
          (index) {
        final prep = value.preparations![index];
        final mnnFromTemplate =
        (prep.medicine?.inn ?? [])
            .whereType<Map<String, dynamic>>()
            .map((item) => MnnModel.fromJson(item))
            .toList();

        return PrepContainerData(
          selectedMNNs: List.from(mnnFromTemplate),
          medicineList: List.from(medicineList),
          preparation: PreparationModel(
            name: prep.name ?? "",
            amount: prep.amount.toString(),
            medicineId: prep.medicineId ?? 0,
            days: prep.days ?? 0,
            timesInDay: prep.timesInDay ?? 0,
            quantity: prep.quantity ?? 0,
            type: prep.type ?? "",
            inn: List.from(mnnFromTemplate),
          ),
          selectedPreparations: [
            PreparationModel(
              name: prep.name ?? "",
              amount: prep.amount.toString(),
              medicineId: prep.medicineId ?? 0,
              days: prep.days ?? 0,
              timesInDay: prep.timesInDay ?? 0,
              quantity: prep.quantity ?? 0,
              type: prep.type ?? "",
              inn: List.from(mnnFromTemplate),
            ),
          ],
        );
      },
    )
        : [
      PrepContainerData(
        selectedMNNs: List.from(widget.selectedMNNs),
        medicineList: List.from(medicineList),
      )
    ];

    setState(() {
      templateName = value.name ?? "";
      diagnosisController.text = value.diagnosis ?? "";
      commentController.text = value.note ?? "";
      preparationContainersData = newData;
      nameControllers.clear();
      debounceTimers.clear();
      nameControllers = List.generate(
        newData.length,
            (i) => TextEditingController(text: newData[i].preparation.name),
      );
      debounceTimers = List.generate(newData.length, (i) => null);
      preparationContainers = List.generate(
        newData.length,
            (i) => _buildPreparationContainer(i),
      );
      lastAddIndex = newData.isEmpty ? -1 : newData.length - 1;
    });

    if (newData.isNotEmpty && newData.last.selectedMNNs.isNotEmpty) {
      context
          .read<CreateTemplateCubit>()
          .getMedicine(inn: newData.last.selectedMNNs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: BlocConsumer<CreateRecepCubit, CreateRecepState>(
        listener: (context, state) {
          if (state is SendTelegramSuccess) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => ReceiptSuccessPage()),
            // );
            _showToast(
              context,'Квитанция успешно отправлена',
              Colors.greenAccent,
            );
            _resetForm();
          } else if (state is CreateRecepError || state is SendTelegramError) {
            _showToast(
              context,
              state is CreateRecepError
                  ? state.failure.errorMsg
                  : 'Telegram xabarini yuborishda xatolik',
              Colors.redAccent,
            );
          }
        },
        builder: (context, state) {
          if (state is CreateRecepLoading) {
            return  Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          return BlocListener<CreateTemplateCubit, CreateTemplateState>(
            listener: (context, cstate) {
              if (cstate is CreateTemplateGetMedicineSuccess) {
                setState(() {
                  medicineList = List.from(cstate.list);
                  if (lastAddIndex >= 0 &&
                      lastAddIndex < preparationContainersData.length) {
                    preparationContainersData[lastAddIndex] =
                        preparationContainersData[lastAddIndex].copyWith(
                          medicineList: List.from(cstate.list),
                        );
                    preparationContainers[lastAddIndex] =
                        _buildPreparationContainer(lastAddIndex);
                  }
                });
              } else if (cstate is CreateTemplateGetMedicineError) {
                _showToast(context, cstate.failure.errorMsg, Colors.redAccent);
              } else if (cstate is CreateTemplateUploadSuccess) {
                _showToast(
                    context,
                    LocaleKeys.create_template_template_created.tr(),
                    Colors.green);
              } else if (cstate is CreateTemplateUploadError) {
                _showToast(context, cstate.failure.errorMsg, Colors.redAccent);
              }
            },
            child: _buildScaffold(context),
          );
        },
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          LocaleKeys.create_recep_title.tr(),
          style:  TextStyle(
            fontFamily: 'VelaSans',
            fontSize: Dimens.space30,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        // leading: IconButton(
        //   icon:  Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            spacing: Dimens.space10,
            children: [
              _buildTemplateSelection(),
              _buildNameField(),
              _buildBirthDateAndNumberField(),
              _buildDiagnosisField(),
              Column(children: preparationContainers),
              UniversalButton.filled(
                onPressed: _addNewContainer,
                cornerRadius: Dimens.space20,
                backgroundColor: AppColors.blueAccent20,
                textColor: AppColors.blueColor,
                text: LocaleKeys.create_recep_add_preparations.tr(),
              ),
              _buildCommentField(),
              UniversalButton.filled(
                text: LocaleKeys.create_recep_save_template.tr(),
                onPressed: _createTemplate,
                fontSize: Dimens.space14,
                backgroundColor: AppColors.blueAccent20,
                textColor: AppColors.blueColor,
                cornerRadius: Dimens.space20,
              ),
              UniversalButton.filled(
                text: LocaleKeys.create_recep_send_recep.tr(),
                onPressed: _createRecep,
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

  Widget _buildTemplateSelection() {
    return Container(
      padding:  EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.space20),
        color: AppColors.white,
      ),
      child: GestureDetector(
        // onTap: () async {
        //   await showModalBottomSheet(
        //     showDragHandle: true,
        //     enableDrag: true,
        //     useSafeArea: true,
        //     isScrollControlled: true,
        //     backgroundColor: AppColors.backgroundColor,
        //     context: context,
        //     builder: (dialogContext) => WillPopScope(
        //       onWillPop: () async {
        //         Navigator.of(dialogContext).pop();
        //         return false;
        //       },
        //       child: TemplatePage(
        //         isBottom: true,
        //         onChange: (TemplateModel value) {
        //           _updateTemplateData(value);
        //           Navigator.of(dialogContext).pop();
        //         },
        //       ),
        //     ),
        //   );
        // },

        child: Container(
          padding:  EdgeInsets.symmetric(
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
                  style:  TextStyle(
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

  Widget _buildNameField() {
    return Container(
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
            LocaleKeys.create_recep_name.tr(),
            style:  TextStyle(
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

  Widget _buildBirthDateAndNumberField() {
    return Container(
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
            LocaleKeys.create_recep_birthdate_and_number.tr(),
            style:  TextStyle(
              fontFamily: 'VelaSans',
              fontSize: Dimens.space18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () => _showDatePickerBottomSheet(context),
            child: AppTextField(
              textColor: Colors.black,
              isEnabled: false,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return LocaleKeys.sign_up_select_date.tr();
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
            prefixIcon:  Text(
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

  Widget _buildDiagnosisField() {
    return Container(
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
            LocaleKeys.create_recep_diagnose.tr(),
            style:  TextStyle(
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

  Widget _buildCommentField() {
    return Container(
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
            LocaleKeys.create_recep_add_comment.tr(),
            style:  TextStyle(
              fontFamily: 'VelaSans',
              fontSize: Dimens.space18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          AppTextField(
            controller: commentController,
            hintText: LocaleKeys.create_recep_write_here.tr(),
            maxLines: 3,
            minLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPreparationContainer(int index) {
    if (index >= preparationContainersData.length ||
        index >= nameControllers.length ||
        index >= debounceTimers.length) {
      return  Text("Index xatosi", style: TextStyle(color: Colors.red));
    }

    final containerData = preparationContainersData[index];
    final med = containerData.preparation;
    final nameController = nameControllers[index];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (containerData.selectedPreparations.isNotEmpty &&
          nameController.text !=
              containerData.selectedPreparations.first.name) {
        nameController.text = containerData.selectedPreparations.first.name;
      }
    });

    const availableTypes = [
      'Tablet',
      'Capsule',
      'Syrup',
      'Injection',
      'Ointment',
      'Cream',
      'Gel',
      'Spray',
      'Inhaler',
      'Drops',
      'Suppository',
      'Powder',
      'Lozenge',
      'Patch',
      'Solution',
      'Suspension',
      'Emulsion',
      'Lotion',
      'Foam',
      'Granules',
      'Ampoule',
      'Vial',
      'Shampoo',
      'Mouthwash',
      'Nasal Spray',
      'Eye Drops',
      'Ear Drops',
      'Nebulizer Solution',
    ];

    return Container(
      key: ValueKey('prep_container_$index'),
      width: double.infinity,
      margin:  EdgeInsets.only(top: 10),
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
                    if (preparationContainersData.length > 1) {
                      preparationContainersData.removeAt(index);
                      nameControllers[index].dispose();
                      nameControllers.removeAt(index);
                      debounceTimers[index]?.cancel();
                      debounceTimers.removeAt(index);
                      preparationContainers = List.generate(
                        preparationContainersData.length,
                            (i) => _buildPreparationContainer(i),
                      );
                      lastAddIndex = lastAddIndex == index
                          ? preparationContainersData.isEmpty
                          ? -1
                          : preparationContainersData.length - 1
                          : lastAddIndex > index
                          ? lastAddIndex - 1
                          : lastAddIndex;
                    } else {
                      _showToast(
                          context, "Kamida bitta dori kerak", Colors.redAccent);
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
          SizedBox(height: 5),
          UniversalButton.filled(
            text: LocaleKeys.create_recep_select_mnn.tr(),
            onPressed: () => showMNN(
              ctx: context,
              model: (value) {},
              mnn: [],
              initialSelectedItems: containerData.selectedMNNs,
              onSelectionComplete: (updatedList) {
                setState(() {
                  lastAddIndex = index;
                  preparationContainersData[index] = containerData.copyWith(
                    selectedMNNs: List.from(updatedList),
                    medicineList: [],
                    selectedPreparations: [],
                    preparation: PreparationModel(
                      name: nameController.text.isNotEmpty ? nameController.text : '',
                      amount: '',
                      quantity: med.quantity > 0 ? med.quantity : 1,       // oldingi qiymatni saqlash
                      timesInDay: med.timesInDay > 0 ? med.timesInDay : 1, // oldingi qiymatni saqlash
                      days: med.days > 0 ? med.days : 1,                   // oldingi qiymatni saqlash
                      type: med.type.isNotEmpty ? med.type : '',
                      medicineId: med.medicineId > 0 ? med.medicineId : 0,
                    ),
                  );

                  if (updatedList.isNotEmpty) {
                    context
                        .read<CreateTemplateCubit>()
                        .getMedicine(inn: updatedList);
                  }
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
              children: containerData.selectedMNNs
                  .asMap()
                  .entries
                  .map(
                    (entry) => Chip(
                  key: ValueKey('mnn_${entry.key}_${entry.value.id}'),
                  label: Text(
                    entry.value.name ?? "null",
                    style:  TextStyle(color: Colors.black),
                  ),
                  deleteIcon:  Icon(Icons.remove_circle),
                  deleteIconColor: AppColors.redAccent,
                  backgroundColor: AppColors.backgroundColor,
                  side: BorderSide.none,
                  onDeleted: () {
                    setState(() {
                      final updatedMNNs = List<MnnModel>.from(
                          containerData.selectedMNNs)
                        ..removeWhere((item) => item.id == entry.value.id);
                      preparationContainersData[index] =
                          containerData.copyWith(
                            selectedMNNs: updatedMNNs,
                            medicineList: [],
                            selectedPreparations: [],
                            preparation: PreparationModel(
                              name: nameController.text.isNotEmpty ? nameController.text : '',
                              amount: '',
                              quantity: med.quantity > 0 ? med.quantity : 1,
                              timesInDay: med.timesInDay > 0 ? med.timesInDay : 1,
                              days: med.days > 0 ? med.days : 1,
                              type: med.type.isNotEmpty ? med.type : '',
                              medicineId: med.medicineId > 0 ? med.medicineId : 0,
                            ),

                          );
                      if (updatedMNNs.isNotEmpty) {
                        context
                            .read<CreateTemplateCubit>()
                            .getMedicine(inn: updatedMNNs);
                      }
                    });
                  },
                ),
              )
                  .toList(),
            ),
          SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: LocaleKeys.create_recep_select_medicine.tr(),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: AppColors.backgroundColor,
              suffixIcon: containerData.medicineList.isNotEmpty
                  ? IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/plus.svg",
                  height: 24,
                  width: 24,
                ),
                onPressed: () {
                  if (containerData.selectedMNNs.isEmpty) {
                    _showToast(context, "Avval MNNlarni tanlang",
                        Colors.redAccent);
                    return;
                  }
                  context
                      .read<CreateTemplateCubit>()
                      .getMedicine(inn: containerData.selectedMNNs);
                  try {
                    showMedicine(
                      ctx: context,
                      model: (value) {
                        setState(() {
                          final newPreparation = PreparationModel(
                            name: value.name ?? "Noma'lum",
                            amount: "${value.prescription ?? ''} ${value.volume ?? ''}".trim(),
                            quantity: med.quantity > 0 ? med.quantity : 1,
                            timesInDay: med.timesInDay > 0 ? med.timesInDay : 1,
                            days: med.days > 0 ? med.days : 1,
                            inn: value.inn != null
                                ? (value.inn as List<dynamic>)
                                .map((item) => MnnModel.fromJson(item as Map<String, dynamic>))
                                .toList()
                                : [],
                            type: value.type ?? "Noma'lum",
                            medicineId: value.id ?? 0,
                          );

                          preparationContainersData[index] =
                              containerData.copyWith(
                                selectedMNNs: value.inn != null
                                    ? (value.inn as List<dynamic>)
                                    .map((item) => MnnModel.fromJson(
                                    item as Map<String, dynamic>))
                                    .toList()
                                    : [],
                                preparation: newPreparation,
                                selectedPreparations: [newPreparation],
                                medicineList: containerData
                                    .medicineList.isNotEmpty
                                    ? List.from(containerData.medicineList)
                                    : List.from(medicineList),
                              );
                          nameControllers[index].text =
                              value.name ?? "Noma'lum";
                          preparationContainers[index] =
                              _buildPreparationContainer(index);
                        });
                        Navigator.of(context).pop();
                      },
                      medicine: containerData.medicineList.isNotEmpty
                          ? containerData.medicineList
                          : medicineList,
                    );
                  } catch (e) {
                    _showToast(
                        context,
                        "Dorilar ro'yxatini ko'rsatishda xatolik",
                        Colors.redAccent);
                  }
                },
              )
                  : null,
            ),
            maxLines: 1,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              debounceTimers[index]?.cancel();
              debounceTimers[index] =
                  Timer( Duration(milliseconds: 300), () {
                    setState(() {
                      final matchingMedicine =
                      containerData.medicineList.firstWhere(
                            (medicine) =>
                        medicine.name?.toLowerCase() == value.toLowerCase(),
                        orElse: () => MedicineModel(
                          name: value,
                          id: 0,
                          type: med.type,
                          inn: containerData.selectedMNNs.isNotEmpty
                              ? List.from(containerData.selectedMNNs)
                              : null,
                        ),
                      );
                      final updatedMed = PreparationModel(
                        name: value,
                        amount: med.amount.isNotEmpty
                            ? med.amount
                            : matchingMedicine.prescription != null &&
                            matchingMedicine.volume != null
                            ? "${matchingMedicine.prescription} ${matchingMedicine.volume}"
                            .trim()
                            : '',
                        quantity: med.quantity > 0 ? med.quantity : 1,
                        timesInDay: med.timesInDay > 0 ? med.timesInDay : 1,
                        days: med.days > 0 ? med.days : 1,
                        type: med.type.isNotEmpty
                            ? med.type
                            : matchingMedicine.type ?? '',
                        medicineId: matchingMedicine.id ?? 0,
                        inn: containerData.selectedMNNs.isNotEmpty
                            ? List.from(containerData.selectedMNNs)
                            : null,
                      );
                      preparationContainersData[index] = containerData.copyWith(
                        preparation: updatedMed,
                        selectedPreparations: [updatedMed],
                      );
                    });
                  });
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value:
                    med.type.isNotEmpty && availableTypes.contains(med.type)
                        ? med.type
                        : null,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    hint:  Text(
                      "Turni tanlang",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    style:  TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black),
                    items: availableTypes
                        .map((type) => DropdownMenuItem<String>(
                        value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          preparationContainersData[index] =
                              containerData.copyWith(
                                preparation: med.copyWith(type: value),
                                selectedPreparations: [med.copyWith(type: value)],
                              );
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    initialValue: med.amount,
                    onChanged: (value) {
                      setState(() {
                        preparationContainersData[index] =
                            containerData.copyWith(
                              preparation: med.copyWith(amount: value),
                              selectedPreparations: [med.copyWith(amount: value)],
                            );
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration:  InputDecoration(
                      hintText: "Miqdori",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    style:  TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CupertinoNumberPicker(
                  key: ValueKey('quantity_picker_$index'),
                  selectedNumber: med.quantity,
                  onChanged: (value) {
                    if (value < 1) return;
                    debounceTimers[index]?.cancel();
                    debounceTimers[index] =
                        Timer( Duration(milliseconds: 300), () {
                          setState(() {
                            preparationContainersData[index] =
                                containerData.copyWith(
                                  preparation: med.copyWith(quantity: value),
                                  selectedPreparations: [med.copyWith(quantity: value)],
                                );
                          });
                        });
                  },
                ),
              ),
              Expanded(
                child: CupertinoNumberPicker(
                  key: ValueKey('times_picker_$index'),
                  selectedNumber: med.timesInDay,
                  onChanged: (value) {
                    if (value < 1) return;
                    debounceTimers[index]?.cancel();
                    debounceTimers[index] =
                        Timer( Duration(milliseconds: 300), () {
                          setState(() {
                            preparationContainersData[index] =
                                containerData.copyWith(
                                  preparation: med.copyWith(timesInDay: value),
                                  selectedPreparations: [
                                    med.copyWith(timesInDay: value)
                                  ],
                                );
                          });
                        });
                  },
                ),
              ),
              Expanded(
                child: CupertinoNumberPicker(
                  key: ValueKey('days_picker_$index'),
                  selectedNumber: med.days,
                  onChanged: (value) {
                    if (value < 1) return;
                    debounceTimers[index]?.cancel();
                    debounceTimers[index] =
                        Timer( Duration(milliseconds: 300), () {
                          setState(() {
                            preparationContainersData[index] =
                                containerData.copyWith(
                                  preparation: med.copyWith(days: value),
                                  selectedPreparations: [med.copyWith(days: value)],
                                );
                          });
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
                        fontWeight: FontWeight.w500, fontSize: Dimens.space12),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    LocaleKeys.create_recep_times.tr(),
                    style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w500, fontSize: Dimens.space12),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    LocaleKeys.create_recep_days.tr(),
                    style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w500, fontSize: Dimens.space12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _createRecep() async {
    if (!_validateForm()) return;

    final token = await SecureStorage().read(key: "accessToken") ?? "";
    if (token.isEmpty) {
      _showToast(
          context, "Autentifikatsiya tokeni topilmadi", Colors.redAccent);
      return;
    }

    final decodedToken = JwtDecoder.decode(token);
    final docID = decodedToken["sub"];

    final validPreparations = preparationContainersData
        .where((e) =>
    e.preparation.name.isNotEmpty && e.preparation.type.isNotEmpty)
        .map((e) => Preparation(
      name: e.preparation.name,
      amount: e.preparation.amount,
      quantity: e.preparation.quantity,
      timesInDay: e.preparation.timesInDay,
      days: e.preparation.days,
      type: e.preparation.type,
      medicineId: e.preparation.medicineId,
      medicine: MedicineModel(
        id: e.preparation.medicineId,
        name: e.preparation.name,
        inn: e.selectedMNNs.isNotEmpty
            ? List.from(e.selectedMNNs)
            : null,
        type: e.preparation.type,
      ),
    ))
        .toList();

    if (validPreparations.isEmpty) {
      _showToast(
          context, LocaleKeys.create_recep_add_medicine.tr(), Colors.redAccent);
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

    final message = _buildTelegramMessage();
    context.read<CreateRecepCubit>().sendTelegramData(
      number: "998${numberController.text.trim().replaceAll(" ", "")}",
      message: message,
    );
  }

  void _createTemplate() async {
    if (!_validateForm()) return;

    if (preparationContainersData.isEmpty) {
      _showToast(
          context, LocaleKeys.create_recep_add_medicine.tr(), Colors.redAccent);
      return;
    }

    final token = await SecureStorage().read(key: "accessToken") ?? "";
    if (token.isEmpty) {
      _showToast(
          context, "Autentifikatsiya tokeni topilmadi", Colors.redAccent);
      return;
    }

    final decodedToken = JwtDecoder.decode(token);
    final uuid = decodedToken["sub"] ?? "";

    final validPreparations = preparationContainersData
        .where((e) =>
    e.preparation.name.isNotEmpty && e.preparation.type.isNotEmpty)
        .map((e) => Preparation(
      name: e.preparation.name,
      amount: e.preparation.amount,
      quantity: e.preparation.quantity,
      timesInDay: e.preparation.timesInDay,
      days: e.preparation.days,
      type: e.preparation.type,
      medicineId: e.preparation.medicineId,
      medicine: MedicineModel(
        id: e.preparation.medicineId,
        name: e.preparation.name,
        inn: e.selectedMNNs.isNotEmpty
            ? List.from(e.selectedMNNs)
            : null,
        type: e.preparation.type,
      ),
    ))
        .toList();

    if (validPreparations.isEmpty) {
      _showToast(context, LocaleKeys.create_recep_select_medicine.tr(),
          Colors.redAccent);
      return;
    }

    final effectiveTemplateName = templateName.isEmpty
        ? diagnosisController.text.trim().isNotEmpty
        ? diagnosisController.text.trim()
        : "Nomsiz shablon ${DateTime.now().millisecondsSinceEpoch}"
        : templateName;

    context.read<CreateTemplateCubit>().uploadTemplate(
      model: UploadTemplateModel(
        name: effectiveTemplateName,
        diagnosis: diagnosisController.text.trim(),
        preparations: validPreparations,
        note: commentController.text.trim(),
        saved: true,
        doctorId: uuid,
      ),
    );
  }

  void _resetForm() {
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
      _addNewContainer();
    });
  }

  String _buildTelegramMessage() {
    var message = '💊 Bemor: ${nameController.text.trim()}\n\n';
    message += 'Tug\'ilgan sana: ${birthDateController.text}\n\n';
    message += '🩺 Diagnoz: ${diagnosisController.text.trim()}\n\n';
    message += '📝 Retsept:\n\n';

    var receiptDetails = '';
    for (var container in preparationContainersData) {
      if (container.preparation.name.isNotEmpty &&
          container.preparation.type.isNotEmpty) {
        final prep = container.preparation;
        final mnnName = container.selectedMNNs.isNotEmpty
            ? '[${container.selectedMNNs.first.name ?? ''}]'
            : '';
        receiptDetails +=
        '✅ ${prep.name} $mnnName ${prep.amount} ${prep.quantity} ${prep.type} * ${prep.timesInDay} marta kuniga (${prep.days} kun)\n';
      }
    }

    message += receiptDetails.isNotEmpty
        ? receiptDetails
        : '✅ Tayinlangan dorilar yo\'q\n';

    if (commentController.text.trim().isNotEmpty) {
      message += '\nIzoh: ${commentController.text.trim()}\n';
    }

    return message;
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      _showValidationError();
      return false;
    }
    return true;
  }

  void _showValidationError() {
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
      _showToast(context, errorMessage, Colors.redAccent);
    }
  }

  void _showToast(BuildContext context, String message, Color backgroundColor) {
    toastification.show(
      style: ToastificationStyle.flat,
      context: context,
      alignment: Alignment.topCenter,
      title: Text(message),
      autoCloseDuration:  Duration(seconds: 2),
      showProgressBar: false,
      primaryColor: Colors.white,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
    );
  }

  Future<void> _showDatePickerBottomSheet(BuildContext ctx) async {
    DateTime dateTime = selectedDate ?? DateTime.now();
    if (birthDateController.text.length == 10) {
      final format = DateFormat("dd/MM/yyyy");
      dateTime = format.parse(birthDateController.text);
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
                style:  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime: dateTime,
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
                  style:  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = dateTime;
                    birthDateController.text =
                        DateFormat('dd/MM/yyyy').format(dateTime);
                  });
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}