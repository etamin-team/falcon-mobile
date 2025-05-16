import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/create_recept/data/model/recep_model.dart';
import 'package:wm_doctor/features/create_recept/presentation/cubit/create_recep_cubit.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import 'package:wm_doctor/features/main/presentation/page/main_page.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_dialog.dart';
import 'package:wm_doctor/features/medicine/presentation/page/mnn_page.dart';
import 'package:wm_doctor/features/template/presentation/page/template.dart';

import '../../../../core/services/secure_storage.dart';
import '../../../../core/utils/data_translate.dart';
import '../../../../core/utils/text_mask.dart';
import '../../../../core/widgets/export.dart';
import '../../../../core/widgets/number_picker.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../auth/sign_up/domain/entity/regison_entity.dart';
import '../../../create_template/data/model/medicine_model.dart';
import '../../../create_template/data/model/upload_template_model.dart';
import '../../../create_template/presentation/cubit/create_template_cubit.dart';

import '../../../home/data/model/PreparationModel.dart';
import '../../../home/data/model/template_model.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../medicine/presentation/page/mnn_dialog.dart';

class PreparationContainerData {
  List<MnnModel> selectedMNNs;

  // preparations aslida ro'yhat emas 1 dona model bo'lishi kerak!!!
  List<PreparationModel> preparations;
  List<MedicineModel> medicineList;

  PreparationContainerData({
    List<MnnModel>? selectedMNNs,
    List<PreparationModel>? preparations,
    List<MedicineModel>? medicineList,
  })  : selectedMNNs = selectedMNNs ?? [],
        preparations = preparations ?? [],
        medicineList = medicineList ?? [];
}

class CreateRecep extends StatefulWidget {
  final List<MnnModel> selectedMNNs;

  const CreateRecep(this.selectedMNNs, {super.key});

  @override
  State<CreateRecep> createState() => _CreateRecepState();
}

class _CreateRecepState extends State<CreateRecep> {
  String templateName = "";
  final diagnosis = TextEditingController();
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  int _selectedYear = DateTime.now().year;
  final commentController = TextEditingController();
  DateTime? selectedDate;
  final formKey = GlobalKey<FormState>();
  List<MedicineModel> medicineList = [];
  int lastAddIndex = -1;
  List<MnnModel> innList = [];

  // List<PreparationModel> preparation = [];
  List<Widget> preparationContainers = [];

  // Container ma'lumotlarini saqlash uchun yangi ro'yxat
  List<PreparationContainerData> preparationContainersData = [];

  List<MnnModel> selectedMNN = MNNPage.getSelectedItems();

  List<Map<String, dynamic>> preps = [
    {
      "name": "Paracetamol",
      "amount": "500 mg",
      "quantity": 2,
      "timesInDay": 3,
      "days": 7,
      "inn": [
        "Acetaminophen",
        "Ibuprofen",
        "Paracetamol",
        "Aspirin",
        "Acetaminophen"
      ],
      "type": "Tablet",
      "medicineId": 1,
    },
  ];

  @override
  void initState() {
    context.read<CreateTemplateCubit>().getMedicine(inn: widget.selectedMNNs);
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
                  preparationContainersData[lastAddIndex].medicineList =
                      cstate.list;

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
                    ];
                  }
                  preparationContainers[lastAddIndex] =
                      buildPreparationContainer(lastAddIndex);
                }
                print("MEDDDD:::${cstate.list.toString()}");
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
                numberController.text = "";
                nameController.text = "";
                commentController.text = "";
                selectedDate = null;
                preparationContainersData.clear();
              }

              print("Current state: ${state.runtimeType}");
              if (state is SendTelegramSuccess) {
                createRecep();
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
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
                                        /*preparation = List.generate(
                                          value.preparations?.length ?? 0,
                                          (index) => PreparationModel(
                                              name: value.preparations?[index].name ??
                                                  "",
                                              amount: value.preparations?[index]
                                                      .amount ??
                                                  "",
                                              quantity: value
                                                      .preparations?[index]
                                                      .quantity ??
                                                  0,
                                              timesInDay: value
                                                      .preparations?[index]
                                                      .timesInDay ??
                                                  0,
                                              days: value.preparations?[index].days ??
                                                  0,
                                              type: value.preparations?[index].type ??
                                                  '',
                                              inn: value.preparations?[index]
                                                  .medicine?.inn,
                                              medicineId:
                                                  value.preparations?[index].medicineId ?? 0),
                                        );*/
                                        // preparation = value.preparations;
                                        diagnosis.text = value.diagnosis ?? "";
                                        commentController.text =
                                            value.note ?? "";
                                        print(
                                            "Template has been imported!!!!!!!!!!!!!!!!!!!!!!!");
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
                                        return LocaleKeys.sign_up_enter_middleName
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
                          children: preparationContainers, // Yangi containerlar shu yerda chiqariladi
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.create_recep_add_preparations.tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: Dimens.space18,
                                    color: Colors.black),
                                textAlign: TextAlign.left,
                              ),
                              GestureDetector(
                                onTap: addPreparationContainer,
                                child: SvgPicture.asset(
                                  Assets.icons.plus,
                                  height: Dimens.space30,
                                  width: Dimens.space30,
                                ),
                              ),
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
                        // Container(
                        //   padding: EdgeInsets.all(Dimens.space20),
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(Dimens.space20),
                        //       color: AppColors.white),
                        //   child: Column(
                        //     spacing: Dimens.space10,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //             "Подписать рецепт",
                        //             style: TextStyle(
                        //  fontFamily: 'VelaSans',
                        //                 fontSize: Dimens.space18,
                        //                 fontWeight: FontWeight.w700),
                        //           ),
                        //           Checkbox(
                        //             activeColor: AppColors.blueColor,
                        //             side: BorderSide(
                        //                 width: 1, color: Colors.grey.shade900),
                        //             value: false,
                        //             onChanged: (value) {},
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(Dimens.space6)),
                        //           )
                        //         ],
                        //       ),
                        //       Row(
                        //         spacing: Dimens.space8,
                        //         children: [
                        //           Expanded(
                        //             child: Container(
                        //               padding: EdgeInsets.symmetric(
                        //                   horizontal: Dimens.space10,
                        //                   vertical: Dimens.space16),
                        //               decoration: BoxDecoration(
                        //                 color: AppColors.blueColor,
                        //                 borderRadius:
                        //                     BorderRadius.circular(Dimens.space10),
                        //               ),
                        //               child: Center(
                        //                   child: Text(
                        //                 "ФИО Врача",
                        //                 style: TextStyle(
                        // fontFamily: 'VelaSans',
                        //                     fontSize: Dimens.space12,
                        //                     color: AppColors.white),
                        //               )),
                        //             ),
                        //           ),
                        //           Expanded(
                        //             child: Container(
                        //               padding: EdgeInsets.symmetric(
                        //                   horizontal: Dimens.space10,
                        //                   vertical: Dimens.space16),
                        //               decoration: BoxDecoration(
                        //                 color: AppColors.backgroundColor,
                        //                 borderRadius:
                        //                     BorderRadius.circular(Dimens.space10),
                        //               ),
                        //               child: Center(
                        //                 child: Text(
                        //                   "Телефон",
                        //                   style: TextStyle(
                        //                   fontFamily: 'VelaSans,fontSize: Dimens.space12),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           Expanded(
                        //             child: Container(
                        //               padding: EdgeInsets.symmetric(
                        //                   horizontal: Dimens.space10,
                        //                   vertical: Dimens.space8),
                        //               decoration: BoxDecoration(
                        //                 color: AppColors.backgroundColor,
                        //                 borderRadius:
                        //                     BorderRadius.circular(Dimens.space10),
                        //               ),
                        //               child: Center(
                        //                 child: Text(
                        //                   textAlign: TextAlign.center,
                        //                   "Название\nЛПУ",
                        //                   style: TextStyle(
                        //                   fontFamily: 'VelaSans,fontSize: Dimens.space12),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        UniversalButton.filled(
                          text: LocaleKeys.create_recep_save_template.tr(),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (preparationContainersData.isEmpty) {
                                toastification.show(
                                  style: ToastificationStyle.flat,
                                  context: context,
                                  alignment: Alignment.topCenter,
                                  title: Text(LocaleKeys
                                      .create_recep_add_medicine
                                      .tr()),
                                  autoCloseDuration: const Duration(seconds: 2),
                                  showProgressBar: false,
                                  primaryColor: Colors.white,
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                );
                              } else {
                                String token = await SecureStorage()
                                        .read(key: "accessToken") ??
                                    "";
                                Map<String, dynamic> decodedToken =
                                    JwtDecoder.decode(token);
                                String docID = decodedToken["sub"];

                                // print(
                                //     "Template saqlashdan oldin: $preparation"); // Tekshirish uchun
                                context
                                    .read<CreateTemplateCubit>()
                                    .uploadTemplate(
                                      model: UploadTemplateModel(
                                        name: diagnosis.text.trim(),
                                        diagnosis: diagnosis.text.trim(),
                                        preparations:
                                            preparationContainersData.map(
                                          (e) {
                                            return Preparation(
                                              name: e.preparations.first.name,
                                              amount:
                                                  e.preparations.first.amount,
                                              quantity:
                                                  e.preparations.first.quantity,
                                              timesInDay: e.preparations.first
                                                  .timesInDay,
                                              days: e.preparations.first.days,
                                              type: e.preparations.first.type,
                                              medicineId: e.preparations.first
                                                  .medicineId,
                                            );
                                          },
                                        ).toList(),
                                        note: commentController.text.trim(),
                                        saved: true,
                                        doctorId: docID,
                                      ),
                                    );

                                // print(
                                //     "Template saqlashdan keyin: $preparation"); // Tekshirish uchun
                              }
                            }
                          },
                          fontSize: Dimens.space14,
                          backgroundColor: AppColors.white,
                          textColor: Colors.black,
                          cornerRadius: Dimens.space20,
                        ),
                        UniversalButton.filled(
                          text: LocaleKeys.create_recep_send_recep.tr(),
                          onPressed: () async {
                            if (formKey.currentState!.validate() &&
                                nameController.text.isNotEmpty &&
                                birthDateController.text.isNotEmpty &&
                                numberController.text.isNotEmpty &&
                                preparationContainersData.isNotEmpty) {
                              String message =
                                  '💊 Пациент: ${nameController.text}\n\n'
                                  'Дата рождения:   ${birthDateController.text}';
                              message = "$message\n\n🩺 Диагноз:\n${diagnosis.text}";
                              message = "$message\n\n🗓 Рецепт:\n";
                              for (var item1 in preparationContainersData) {
                                String mnnLsString =
                                    item1.selectedMNNs.isNotEmpty
                                        ? "${item1.selectedMNNs}\n"
                                        : "";

                                String preparationMessage = "";
                                if (item1.preparations.isNotEmpty) {
                                  var item = item1.preparations.first;
                                  preparationMessage =
                                      "$message\n✅ ${item.name} ${item.amount} ${item.quantity} ${item.type} * ${item.timesInDay} раз в день  (${item.days} дней)";
                                }

                                message = mnnLsString + preparationMessage;
                              }


                              message = "$message\n\nПримечание: ${commentController.text}";

                              print("call back qaytdi");

                              context.read<CreateRecepCubit>().sendTelegramData(
                                  number:
                                      "998${numberController.text.trim().replaceAll(" ", "")}" ??
                                          "0",
                                  message: message);
                              createRecep();
                              print("----------------------------------------");
                              print("----------------------------------------");

                              print(message);
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

  // Future<void> showDatePickerBottomSheet(BuildContext ctx) async {
  //   int dateTime = DateTime.now().year;
  //
  //   return showModalBottomSheet(
  //     context: ctx,
  //     isScrollControlled: true,
  //     showDragHandle: true,
  //     enableDrag: true,
  //     // BottomSheet o'lchamini moslashuvchan qiladi
  //     backgroundColor: Colors.white,
  //     // shape: const RoundedRectangleBorder(
  //     //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     // ),
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 320,
  //         color: Colors.white,
  //         child: Column(
  //           children: [
  //             SizedBox(
  //               height: 250,
  //               child: CupertinoPicker(
  //                 scrollController: FixedExtentScrollController(
  //                   initialItem:
  //                       _selectedYear - 1900, // Boshlang'ich yilni ko‘rsatish
  //                 ),
  //                 itemExtent: 40,
  //                 onSelectedItemChanged: (int index) {
  //                   setState(() {
  //                     dateTime = 1901 + index;
  //                   });
  //                 },
  //                 children: List<Widget>.generate(DateTime.now().year - 1900,
  //                     (int index) {
  //                   return Center(
  //                     child: Text(
  //                       '${1901 + index}',
  //                       style: TextStyle(fontFamily: 'VelaSans', fontSize: 22),
  //                     ),
  //                   );
  //                 }),
  //               ),
  //             ),
  //             CupertinoButton(
  //               child: Text(
  //                 LocaleKeys.create_recep_select.tr(),
  //                 style: TextStyle(
  //                     fontFamily: 'VelaSans',
  //                     color: AppColors.blueColor,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //               onPressed: () {
  //                 _selectedYear = dateTime;
  //                 dateTimeController.text = _selectedYear.toString();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
  showMedicineList({required ValueChanged<MnnModel> onChange}) {
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
                innList.length,
                (index) {
                  return ListTile(
                    onTap: () {
                      onChange(innList[index]);
                      Navigator.pop(context);
                    },
                    title: Text(innList[index].name ?? ""),
                  );
                },
              ),
            ).paddingOnly(bottom: 20),
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

  void showInputAmount(
      {required String name,
      required double amount,
      required ValueChanged<double> onChange}) async {
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
                style: TextStyle(
                    fontSize: Dimens.space18, fontWeight: FontWeight.w500),
              ),
              AppTextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "kamida 1 ta bo'lishi kerak";
                  }
                  int number = int.tryParse(value.toString()) ?? 0;
                  if (number < 1) {
                    return "0 bo'lmasligi kerak";
                  }
                  return null;
                },
                maxLen: 5,
                controller: textController,
                hintText: "1",
              ),
              UniversalButton.filled(
                text: "Сохранять",
                onPressed: () {
                  if (quantForm.currentState!.validate()) {
                    double number =
                        double.tryParse(textController.text.toString()) ?? 1;
                    onChange(number);
                    Navigator.pop(context);
                  }
                },
                fontSize: Dimens.space14,
                cornerRadius: Dimens.space20,
              ),
              SizedBox(
                height: Dimens.space50,
              )
            ],
          ).paddingOnly(
              left: Dimens.space30,
              right: Dimens.space30,
              top: Dimens.space20,
              bottom: MediaQuery.viewInsetsOf(context).bottom),
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
            lastName: "" /*nameController.text*/,
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
              PreparationModel? item =
                  preparationContainersData[index].preparations.firstOrNull;
              return Preparation(
                  name: item?.name ?? "",
                  amount: item?.amount ?? "",
                  quantity: item?.quantity ?? 0,
                  timesInDay: item?.timesInDay ?? 0,
                  days: item?.days ?? 0,
                  type: item?.type ?? "null",
                  medicineId: item?.medicineId ?? 0);
            })));
  }
  // Container qo'shish uchun metod
  void addPreparationContainer() {
    setState(() {
      PreparationContainerData newData = PreparationContainerData(
        selectedMNNs: [],
        preparations: [], // Default ma'lumotlardan nusxa olish
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
      return Container(
        child: Text(
          "Index xatosi",
          style: TextStyle(color: Colors.red),
        ),
      ); // Xatolikni oldini olish uchun bo'sh container qaytarish
    }

    PreparationContainerData containerData = preparationContainersData[index];

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
                    color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  removePreparationContainer();
                },
                child: SvgPicture.asset(
                  "assets/icons/minus.svg",
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
          // TODO(Tempdata'dan qaytgan ma'lumot qo'yilsin)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.space10,
            children: [
              SizedBox(
                height: 5,
              ),
              UniversalButton.filled(
                text: "Select MNN",
                onPressed: () => showMNN(
                  ctx: context,
                  model: (value) {
                    // Kerakli bo'lsa MNN modelini alohida qo'shish
                    if (mounted) {
                      setState(() {});
                    }
                    Navigator.pop(context);
                  },
                  mnn: [],
                  medicine: [],
                  initialSelectedItems: containerData.selectedMNNs,
                  onSelectionComplete: (updatedList) async {
                    if (mounted) {
                      lastAddIndex = index;
                      context
                          .read<CreateTemplateCubit>()
                          .getMedicine(inn: updatedList);
                      setState(() {
                        containerData.selectedMNNs = updatedList;
                        // Containerlarni yangilash
                        preparationContainers[index] =
                            buildPreparationContainer(index);
                      });

                      Future.delayed(
                        Duration(milliseconds: 300),
                        () {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (timeStamp) {
                              print(
                                  "MEDDDD2:::${containerData.medicineList.toString()}");
                              /*if (containerData.medicineList.isNotEmpty) {
                                preparationContainersData[index].preparations =
                                    [
                                  PreparationModel(
                                    name:
                                        containerData.medicineList.first.name ??
                                            "",
                                    amount:
                                        "${containerData.medicineList.first.prescription} ${containerData.medicineList.first.volume}",
                                    quantity: 0,
                                    timesInDay: 0,
                                    days: 0,
                                    inn: containerData.medicineList.first.inn,
                                    type:
                                        containerData.medicineList.first.type ??
                                            "",
                                    medicineId:
                                        containerData.medicineList.first.id ??
                                            0,
                                  ),
                                ];
                              }
                              preparationContainers[index] =
                                  buildPreparationContainer(index);*/
                            },
                          );
                        },
                      );
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
                      children: containerData.selectedMNNs
                          .map(
                            (mnn) => Chip(
                              label: Text(
                                mnn.name ?? "nullga tekshir",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : SizedBox.shrink(),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.space20,
                  vertical: Dimens.space16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                Expanded(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  containerData.preparations.isNotEmpty
                      ?
                  containerData.preparations.first.name ?? ""
                        : "Select medicine",
                    style: TextStyle(
                        fontFamily: 'VelaSans',
                        fontSize: Dimens.space14,
                        color: Colors.black),
                ),
              ),
                      // containerData.preparations.first.name
                    GestureDetector(
                      onTap: () {
                        if (containerData.preparations.isNotEmpty) {
                          containerData.preparations.clear();
                          setState(() {
                            preparationContainers[index] =
                                buildPreparationContainer(index);
                          });
                        } else {
                          print(
                              "CreateRecept:::medicineList==>${containerData.medicineList}");
                          //Dialog ochish uchun
                          showMedicine(
                            ctx: context,
                            model: (value) {
                              containerData.preparations.add(
                                PreparationModel(
                                  name: value.name ?? "",
                                  amount:
                                      "${value.prescription} ${value.volume}",
                                  quantity: 1,
                                  timesInDay: 1,
                                  days: 1,
                                  inn: value.inn,
                                  type: value.type ?? "",
                                  medicineId: value.id ?? 0,
                                ),
                              );
                              setState(() {
                                preparationContainers[index] =
                                    buildPreparationContainer(index);
                              });
                              Navigator.pop(context);
                            },
                            medicine: containerData.medicineList,
                          );
                        }

                        setState(() {
                          print(selectedMNN);
                          print(
                            "111111111111111111111111",
                          );
                        });
                      },
                      child: SvgPicture.asset(
                        containerData.preparations.isEmpty
                            ? "assets/icons/plus.svg"
                            : "assets/icons/minus.svg",
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ...containerData.preparations.map((med) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(med.type,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              /*print("bosildi::: ${med.amount}");
                              double number = double.tryParse(med.amount
                                  .replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
                              // double number = double.parse(med.amount
                              //     .replaceAll(RegExp(r'[^0-9.]'), ''));
                              String onlyText = med.amount
                                  .replaceAll(RegExp(r'[0-9]'), '')
                                  .trim();
                              setState(() {
                                med.amount = "${number + 100} $onlyText";
                              });*/
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(med.amount,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12)),
                                  // Icon(Icons.keyboard_arrow_down, size: 20),
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
                                  fontSize: Dimens.space12),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              LocaleKeys.create_recep_times.tr(),
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dimens.space12),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              LocaleKeys.create_recep_days.tr(),
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dimens.space12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              /*...containerData.preparations.map((med) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  spacing: Dimens.space10,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          LocaleKeys.create_recep_quantity.tr(),
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimens.space12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          LocaleKeys.create_recep_times.tr(),
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimens.space12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          LocaleKeys.create_recep_days.tr(),
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimens.space12),
                        ),
                      ),
                    ),
                  ],
                );
              }),*/
            ],
          ),
          /*...preps.map((med) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.space10,
              children: [
                SizedBox(
                  height: 5,
                ),
                UniversalButton.filled(
                  text: "Select MNN",
                  onPressed: () => showMNN(
                    ctx: context,
                    model: (value) {
                      // Kerakli bo'lsa MNN modelini alohida qo'shish
                      if (mounted) {
                        setState(() {});
                      }
                      Navigator.pop(context);
                    },
                    mnn: [],
                    medicine: [],
                    initialSelectedItems: containerData.selectedMNNs,
                    onSelectionComplete: (updatedList) {
                      if (mounted) {
                        context
                            .read<CreateTemplateCubit>()
                            .getMedicine(inn: updatedList);
                        setState(() {
                          containerData.selectedMNNs = updatedList;
                          // Containerlarni yangilash
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
                        children: containerData.selectedMNNs
                            .map(
                              (mnn) => Chip(
                                label: Text(
                                  mnn.name ?? "nullga tekshir",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : SizedBox.shrink(),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.space20,
                    vertical: Dimens.space16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "tempdata",
                        style: TextStyle(
                            fontFamily: 'VelaSans',
                            fontSize: Dimens.space14,
                            color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (containerData.preparations.isNotEmpty) {
                            containerData.preparations.clear();
                            setState(() {
                              preparationContainers[index] =
                                  buildPreparationContainer(index);
                            });
                          } else {
                            print(
                                "CreateRecept:::medicineList==>$medicineList");
                            //Dialog ochish uchun
                            showMedicine(
                              ctx: context,
                              model: (value) {
                                containerData.preparations.add(
                                  PreparationModel(
                                    name: value.name ?? "",
                                    amount:
                                        "${value.prescription} ${value.volume}",
                                    quantity: 0,
                                    timesInDay: 0,
                                    days: 0,
                                    inn: value.inn,
                                    type: value.type ?? "",
                                    medicineId: value.id ?? 0,
                                  ),
                                );
                                setState(() {
                                  preparationContainers[index] =
                                      buildPreparationContainer(index);
                                });
                                Navigator.pop(context);
                              },
                              medicine: medicineList,
                            );
                          }

                          setState(() {
                            print(selectedMNN);
                            print(
                              "111111111111111111111111",
                            );
                          });
                        },
                        child: SvgPicture.asset(
                          containerData.preparations.isEmpty
                              ? "assets/icons/plus.svg"
                              : "assets/icons/minus.svg",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(med["type"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          double number = double.parse(
                              med["amount"].replaceAll(RegExp(r'[^0-9.]'), ''));
                          String onlyText = med["amount"]
                              .replaceAll(RegExp(r'[0-9]'), '')
                              .trim();
                          setState(() {
                            med["amount"] = "${number + 100} $onlyText";
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(med["amount"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                              Icon(Icons.keyboard_arrow_down, size: 20),
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
                        selectedNumber: med["quantity"],
                        onChanged: (int value) {
                          setState(() {
                            med["quantity"] = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoNumberPicker(
                        selectedNumber: med["timesInDay"],
                        onChanged: (int value) {
                          setState(() {
                            med["timesInDay"] = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoNumberPicker(
                        selectedNumber: med["days"],
                        onChanged: (int value) {
                          setState(() {
                            med["days"] = value;
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
                              fontSize: Dimens.space12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          LocaleKeys.create_recep_times.tr(),
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimens.space12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          LocaleKeys.create_recep_days.tr(),
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w500,
                              fontSize: Dimens.space12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }).toList(),*/
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
}
