import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/create_recept/data/model/recep_model.dart';
import 'package:wm_doctor/features/create_recept/presentation/cubit/create_recep_cubit.dart';
import 'package:wm_doctor/features/create_recept/presentation/page/receipt_success.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import 'package:wm_doctor/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_dialog.dart';
import 'package:wm_doctor/features/medicine/presentation/page/mnn_page.dart';
import 'package:wm_doctor/features/template/presentation/page/templates.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../core/utils/text_mask.dart';
import '../../../../core/widgets/export.dart';
import '../../../../core/widgets/number_picker.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../create_template/data/model/medicine_model.dart';
import '../../../create_template/data/model/upload_template_model.dart';
import '../../../create_template/presentation/cubit/create_template_cubit.dart';
import '../../../home/data/model/PreparationModel.dart';
import '../../../home/data/model/template_model.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../medicine/presentation/page/mnn_dialog.dart';

class PrepContainerData {
  List<MnnModel> selectedMNNs;
  PreparationModel preparations;
  List<PreparationModel> selectedPreparations;
  List<MedicineModel> medicineList;

  PrepContainerData({
    List<MnnModel>? selectedMNNs,
    PreparationModel? preparation,
    List<PreparationModel>? selectedPreparations,
    List<MedicineModel>? medicineList,
  })  : selectedMNNs = selectedMNNs ?? [],
        preparations = preparation ?? PreparationModel(name: '', amount: '', quantity: 0, timesInDay: 0, days: 0, type: '', medicineId: 0),
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
      preparation: preparation ?? this.preparations,
      selectedPreparations: selectedPreparations ?? this.selectedPreparations,
      medicineList: medicineList ?? this.medicineList,
    );
  }
}

class CreateRecep extends StatefulWidget {
  final List<MnnModel> selectedMNNs;
  const CreateRecep(this.selectedMNNs);
  @override
  State<CreateRecep> createState() => _CreateRecepState();
}

class _CreateRecepState extends State<CreateRecep> {
  String templateName = "";
  final diagnosis = TextEditingController();
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  final commentController = TextEditingController();
  DateTime? selectedDate;
  final formKey = GlobalKey<FormState>();
  List<MedicineModel> medicineList = [];
  int lastAddIndex = -1;
  List<MnnModel> mnn = [];

  // List<PreparationModel> preparation = [];
  List<Widget> preparationContainers = [];

  List<PrepContainerData> preparationContainersData = [];

  List<MnnModel> selectedMNN = MNNPage.getSelectedItems();
  List<PreparationModel> selectedPreparations = [];

  @override
  void initState() {
    context.read<CreateTemplateCubit>().getMedicine(inn: widget.selectedMNNs);
    context.read<MedicineCubit>().getMedicine();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          context
              .read<HomeCubit>()
              .getTemplate(saved: "", sortBy: "", searchText: "");
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
        }
      },
      builder: (context, state) {
        if (state is CreateTemplateUploadLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return BlocListener<CreateTemplateCubit, CreateTemplateState>(
          listener: (context, cstate) {
            if (cstate is CreateTemplateGetMedicineSuccess) {
              setState(() {
                if (lastAddIndex == -1) {
                  medicineList = cstate.list;
                } else {
                  preparationContainersData[lastAddIndex].medicineList = cstate.list;

                  if (cstate.list.isNotEmpty) {
                    preparationContainersData[lastAddIndex].preparations = [
                      PreparationModel(
                        name: cstate.list.first.name ?? "",
                        amount:
                        "${cstate.list.first.prescription} ${cstate.list.first.volume}",
                        quantity: 0,
                        timesInDay: 0,
                        days: 0,
                        inn: cstate.list.first.inn,
                        type: cstate.list.first.type ?? "",
                        medicineId: cstate.list.first.id ?? 0,
                      ),
                    ] as PreparationModel;
                  }
                  preparationContainers[lastAddIndex] =
                      buildPreparationContainer(lastAddIndex);
                }
                if (kDebugMode) {
                  print("MEDDDD:::${cstate.list.toString()}");
                }
              });
            }
            /*if (cstate is CreateTemplateGetMedicineSuccess) {
              setState(() {
                medicineList = cstate.list;
              });
            }*/
          },
          child: BlocConsumer<CreateRecepCubit, CreateRecepState>(
            listener: (context, cstate) {
              if (cstate is CreateRecepSuccess) {
                templateName = "";
                diagnosis.text = "";
                birthDateController.text = "";
                numberController.text = "";
                nameController.text = "";
                commentController.text = "";
                selectedDate = null;
                preparationContainersData.clear();
                preparationContainers.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptSuccessPage()));
              }
              if (state is SendTelegramError) {
                toastification.show(
                  style: ToastificationStyle.simple,
                  context: context,
                  alignment: Alignment.topCenter,
                  title: Text("Current state: ${state.runtimeType}"),
                  autoCloseDuration: const Duration(seconds: 4),
                  showProgressBar: false,
                  primaryColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                );
              }
              if(state is SendTelegramSuccess){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReceiptSuccessPage()));
              }

              if (kDebugMode) {
                print("Current state: ${state.runtimeType}");
              }
            },
            builder: (context, state) {
              if (state is CreateRecepLoading) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Scaffold(
                backgroundColor: AppColors.backgroundColor,
                appBar: AppBar(
                  forceMaterialTransparency: true,
                  title: Text(
                    LocaleKeys.create_recep_title.tr(),
                    style: TextStyle(
                        fontFamily: 'VelaSans',
                        fontSize: Dimens.space30,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      spacing: Dimens.space10,
                      children: [
                        Container(
                          padding: EdgeInsets.all(Dimens.space20),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimens.space20),
                              color: AppColors.white),
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
                                            selectedMNNs: selectedMNN,
                                            medicineList: medicineList,
                                            preparation: PreparationModel(name: value.name.toString(), amount: value.preparations![index].amount.toString(), medicineId: value.preparations![index].medicineId ?? 0, days: value.preparations![index].days ?? 0, timesInDay: value.preparations![index].timesInDay ?? 0, quantity: value.preparations![index].quantity ?? 0, type: value.preparations![index].type.toString(),),
                                          ),
                                        );
                                        preparationContainers = List.generate(
                                          value.preparations?.length ?? 0,
                                              (index) => buildPreparationContainer(index),
                                        );
                                        diagnosis.text = value.diagnosis ?? "";
                                        commentController.text =
                                            value.note ?? "";
                                        if (kDebugMode) {
                                          print(
                                              "Template has been imported!!!!!!!!!!!!!!!!!!!!!!!");
                                        }
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.space14,
                                  vertical: Dimens.space16),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius:
                                  BorderRadius.circular(Dimens.space10)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                spacing: Dimens.space10,
                                children: [
                                  Expanded(
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      templateName == ""
                                          ? LocaleKeys
                                          .create_recep_select_template
                                          .tr()
                                          : templateName,
                                      style: TextStyle(
                                          fontFamily: 'VelaSans',
                                          fontSize: Dimens.space14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimens.space5,
                                  ),
                                  Icon(CupertinoIcons.chevron_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(Dimens.space20),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimens.space20),
                              color: AppColors.white),
                          child: Column(
                            spacing: Dimens.space10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.create_recep_name.tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space18,
                                    fontWeight: FontWeight.w700),
                              ),
                              AppTextField(
                                  controller: nameController,
                                  hintText: LocaleKeys.create_recep_name.tr()),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(Dimens.space20),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimens.space20),
                              color: AppColors.white),
                          child: Column(
                            spacing: Dimens.space10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                LocaleKeys.create_recep_birthdate_and_number
                                    .tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space18,
                                    fontWeight: FontWeight.w700),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDatePickerBottomSheet(context);
                                },
                                child: AppTextField(
                                    textColor: Colors.black,
                                    isEnabled: false,
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return LocaleKeys
                                            .sign_up_enter_middleName
                                            .tr();
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.datetime,
                                    formatter: [
                                      TextMask(pallet: '##/##/####'),
                                      // DateFormatter(),
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    suffixIcon: InkWell(
                                      // onTap: () {
                                      //   showDatePickerBottomSheet(context);
                                      // },
                                      child: SvgPicture.asset(
                                        Assets.icons.calendar,
                                        height: Dimens.space14,
                                        width: Dimens.space14,
                                      ).paddingAll(value: Dimens.space10),
                                    ),
                                    controller: birthDateController,
                                    hintText: "29/11/2001"),
                              ),
                              AppTextField(
                                  prefixIcon: Text(
                                    textAlign: TextAlign.center,
                                    "+998  ",
                                    style: TextStyle(
                                        fontFamily: 'VelaSans',
                                        color: Colors.black),
                                  ),
                                  // validator: (value) {
                                  //   if (value.toString().length != 12) {
                                  //     return "Введите номер правильно.";
                                  //   }
                                  //   return null;
                                  // },
                                  keyboardType: TextInputType.phone,
                                  formatter: [
                                    TextMask(pallet: '## ### ## ##'),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\+?[0-9\s]*$'),
                                        replacementString: ""),
                                    LengthLimitingTextInputFormatter(12),
                                  ],
                                  controller: numberController,
                                  hintText: " 90 123 45 67"),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(Dimens.space20),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimens.space20),
                              color: AppColors.white),
                          child: Column(
                            spacing: Dimens.space10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                LocaleKeys.create_recep_diagnose.tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space18,
                                    fontWeight: FontWeight.w700),
                              ),
                              AppTextField(
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return LocaleKeys
                                          .create_recep_enter_diagnose
                                          .tr();
                                    }
                                    return null;
                                  },
                                  controller: diagnosis,
                                  hintText:
                                  LocaleKeys.create_recep_write_here.tr()),
                            ],
                          ),
                        ),
                        Column(
                          children:
                          preparationContainers, // Yangi containerlar shu yerda chiqariladi
                        ),
                        UniversalButton.filled(
                          onPressed: addPreparationContainer,
                          cornerRadius: Dimens.space20,
                          backgroundColor: AppColors.blueAccent20,
                          text: LocaleKeys.create_recep_add_preparations.tr(),
                          textColor: AppColors.blueColor,
                        ),
                        Container(
                          padding: EdgeInsets.all(Dimens.space20),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimens.space20),
                              color: AppColors.white),
                          child: Column(
                            spacing: Dimens.space10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.create_recep_add_comment.tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space18,
                                    fontWeight: FontWeight.w700),
                              ),
                              AppTextField(
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return LocaleKeys.create_recep_enter_comment
                                        .tr();
                                  }
                                  return null;
                                },
                                controller: commentController,
                                hintText:
                                LocaleKeys.create_recep_write_here.tr(),
                                maxLines: 3,
                                minLines: 3,
                              ),
                            ],
                          ),
                        ),
                        UniversalButton.filled(
                          text: LocaleKeys.create_recep_send_recep.tr(),
                          onPressed: () async {
                            if (formKey.currentState!.validate() &&
                                nameController.text.isNotEmpty &&
                                birthDateController.text.isNotEmpty &&
                                numberController.text.isNotEmpty &&
                                preparationContainersData.isNotEmpty) {
                              String message = '💊 Пациент: ${nameController.text}\n\n'
                                  'Дата рождения:   ${birthDateController.text}\n\n'
                                  '🩺 Диагноз:\n${diagnosis.text}\n\n'
                                  '🗓 Рецепт:\n';

                              String receiptDetails = '';

                              // Har bir PrepContainerData uchun ma'lumotlarni ko‘rib chiqamiz
                              for (var container in preparationContainersData) {

                                if (container.selectedMNNs.isNotEmpty && container.selectedPreparations.isNotEmpty) {
                                  for (int i = 0; i < container.selectedPreparations.length; i++) {
                                    var prep = container.selectedPreparations[i];
                                    // Agar MNNlar soni preparatlarga mos kelsa, ularni birlashtiramiz
                                    String? mnnName = container.selectedMNNs.length > i ? container.selectedMNNs[i].name : '';
                                    receiptDetails += '✅ [$mnnName] ${prep.name} ${prep.amount} ${prep.quantity} ${prep.type} * ${prep.timesInDay} раз в день  (${prep.days} дней)\n';
                                  }
                                }
                                // 2-holat: Faqat preparatlar
                                else if (container.selectedPreparations.isNotEmpty) {
                                  for (var prep in container.selectedPreparations) {
                                    receiptDetails += '✅ ${prep.name} ${prep.amount} ${prep.quantity} ${prep.type} * ${prep.timesInDay} раз в день  (${prep.days} дней)\n';
                                  }
                                }
                                // 3-holat: Faqat MNNlar
                                else if (container.selectedMNNs.isNotEmpty) {
                                  for (var mnn in container.selectedMNNs) {
                                    receiptDetails += '[${mnn.name}]\n';
                                  }
                                }
                              }

                              // Agar receiptDetails bo‘sh bo‘lmasa, qo‘shish
                              if (receiptDetails.isNotEmpty) {
                                message += receiptDetails;
                              } else {
                                message += 'Hech qanday dori yoki MNN tanlanmagan\n';
                              }

                              // Примечание qo‘shish
                              message += '\nПримечание: ${commentController.text}';

                              print("call back qaytdi");
                              context.read<CreateRecepCubit>().sendTelegramData(
                                  number: "998${numberController.text.trim().replaceAll(" ", "")}",
                                  message: message);
                            }
                            if (nameController.text.isEmpty) {
                              toastification.show(
                                style: ToastificationStyle.flat,
                                context: context,
                                alignment: Alignment.topCenter,
                                title: Text(
                                    LocaleKeys.create_recep_enter_name.tr()),
                                autoCloseDuration: const Duration(seconds: 4),
                                showProgressBar: false,
                                primaryColor: Colors.white,
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              );
                            } else if (birthDateController.text.isEmpty) {
                              toastification.show(
                                style: ToastificationStyle.flat,
                                context: context,
                                alignment: Alignment.topCenter,
                                title: Text(LocaleKeys
                                    .create_recep_enter_birthdate
                                    .tr()),
                                autoCloseDuration: const Duration(seconds: 4),
                                showProgressBar: false,
                                primaryColor: Colors.white,
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              );
                            } else if (numberController.text.length != 12) {
                              toastification.show(
                                style: ToastificationStyle.flat,
                                context: context,
                                alignment: Alignment.topCenter,
                                title: Text(
                                    LocaleKeys.create_recep_enter_number.tr()),
                                autoCloseDuration: const Duration(seconds: 4),
                                showProgressBar: false,
                                primaryColor: Colors.white,
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              );
                            } else if (preparationContainersData.isEmpty) {
                              toastification.show(
                                style: ToastificationStyle.flat,
                                context: context,
                                alignment: Alignment.topCenter,
                                title: Text(
                                    LocaleKeys.create_recep_add_medicine.tr()),
                                autoCloseDuration: const Duration(seconds: 4),
                                showProgressBar: false,
                                primaryColor: Colors.white,
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              );
                            }
                          },
                          fontSize: Dimens.space14,
                          backgroundColor: AppColors.blueColor,
                          cornerRadius: Dimens.space20,
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: Dimens.space20),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> showDatePickerBottomSheet(BuildContext ctx) async {
    if (birthDateController.text.length == 10) {
      DateFormat format = DateFormat("dd/MM/yyyy");
      selectedDate = format.parse(birthDateController.text.toString());
    }
    DateTime dateTime = DateTime.now();
    if (selectedDate != null) {
      dateTime = selectedDate!;
    }
    return showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      // BottomSheet o'lchamini moslashuvchan qiladi
      backgroundColor: Colors.white,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      // ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              const SizedBox(height: 30),
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
                  initialDateTime:
                  selectedDate == null ? DateTime.now() : selectedDate!,
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
                  if (formKey.currentState!.validate()) {}
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  void showMedicineList({required ValueChanged<MnnModel> onChange}) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        final ScrollController scrollController = ScrollController();
        int batchSize = 20;
        List<MnnModel> displayedMnn = mnn.take(batchSize).toList();
        bool isLoading = false;

        scrollController.addListener(() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.8 &&
              !isLoading &&
              displayedMnn.length < mnn.length) {
            isLoading = true;
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                displayedMnn.addAll(
                  mnn.skip(displayedMnn.length).take(batchSize).toList(),
                );
                isLoading = false;
              });
            });
          }
        });

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return ListView.builder(
                controller: scrollController,
                itemCount: displayedMnn.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayedMnn.length && isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListTile(
                    onTap: () {
                      onChange(displayedMnn[index]);
                      Navigator.pop(context);
                    },
                    title: Text(displayedMnn[index].name.toString()),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  showMedicineTypeList({required ValueChanged<String> onChange}) {
    List<String> types = ["PILLS", "TYPE2", "TYPE3"];
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                types.length,
                    (index) {
                  return ListTile(
                    onTap: () {
                      onChange(types[index]);
                      Navigator.pop(context);
                    },
                    title: Text(types[index]),
                  );
                },
              ),
            ).paddingOnly(bottom: 20),
          ),
        );
      },
    );
  }

  void createRecep() async {
      print("=================================================");
      print("=================================================");
      print("=================================================");
      print("=================================================");
      String token = await SecureStorage().read(key: "accessToken") ?? "";
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String docID = decodedToken["sub"];
      context.read<CreateRecepCubit>().saveRecep(
          model: RecepModel(
              doctorId: docID,
              firstName: nameController.text,
              lastName: "",
              dateOfBirth: selectedDate ?? DateTime.now(),
              phoneNumber: numberController.text.trim().replaceAll(" ", ""),
              phoneNumberPrefix: "+998",
              dateCreation: DateTime.now(),
              diagnosis: diagnosis.text.toString(),
              comment: commentController.text,
              telegramId: 0,
              districtId: 100,
              preparations:
              List.generate(preparationContainersData.length, (index) {
                PreparationModel? item = preparationContainersData[index].preparations;
                return Preparation(
                    name: item.name ,
                    amount: item.amount ,
                    quantity: item.quantity,
                    timesInDay: item.timesInDay,
                    days: item.days,
                    type: item.type,
                    medicineId: item.medicineId,
                    medicine: MedicineModel(id: item.medicineId));
              })));
  }

  // Container qo'shish uchun metod
  void addPreparationContainer() {
    setState(() {
      PrepContainerData newData = PrepContainerData(
        selectedMNNs: [],
        preparation: PreparationModel(name: "", amount: "", quantity: 0, timesInDay: 0, days: 0, type: "", medicineId: 0), // Default ma'lumotlardan nusxa olish
        medicineList: medicineList, // Default ma'lumotlardan nusxa olish
      );
      preparationContainersData.add(newData);

      // Yangi containerni qo'shish
      preparationContainers
          .add(buildPreparationContainer(preparationContainersData.length - 1));
    });
  }

  Widget buildPreparationContainer(int index) {
    if (index >= preparationContainersData.length) {
      return Text(
        "Index error",
        style: TextStyle(color: Colors.red),
      );
    }

    PrepContainerData containerData = preparationContainersData[index];

    return Container(
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
                  removePreparationContainer();
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
                text: "Select MNN",
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
                      lastAddIndex = index;
                      context
                          .read<CreateTemplateCubit>()
                          .getMedicine(inn: updatedList);
                      setState(() {
                        containerData.selectedMNNs = updatedList;
                        preparationContainers[index] =
                            buildPreparationContainer(index);
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
                children: containerData.selectedMNNs.map((mnn) => Chip(
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
                      containerData.selectedMNNs.remove(mnn);
                      preparationContainers[index] = buildPreparationContainer(index);
                    });
                  },
                )).toList(),
              )
                  : SizedBox.shrink(),
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
                            : "Select medicine",
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

  // Container o'chirish uchun metod
  void removePreparationContainer() {
    setState(() {
      if (preparationContainers.isNotEmpty) {
        preparationContainers.removeAt(preparationContainers.length - 1);
        if (preparationContainersData.isNotEmpty) {
          preparationContainersData
              .removeAt(preparationContainersData.length - 1);
        }
      }
    });
  }
  void showMedicines({
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

}