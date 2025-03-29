import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/presentation/cubit/edit_contract_cubit.dart';

import '../../../../../core/model/language_model.dart';
import '../../../../../core/utils/data_translate.dart';
import '../../../../../core/widgets/export.dart';
import '../../../../auth/sign_up/data/model/workplace_model.dart';
import '../../../../create_template/data/model/medicine_model.dart';
import '../../../../medicine/presentation/page/medicine_dialog.dart';
import '../../../../regions/data/model/district_model.dart';
import '../../../add_doctor/data/model/add_contract_model.dart';
import '../../../home/data/model/doctors_model.dart';
import '../../../home/presentation/cubit/agent_home_cubit.dart';

class AgentCreateContract extends StatefulWidget {
  final DoctorsModel model;
  final WorkplaceModel? workplaceModel;
  final DistrictModel? districtModel;
  const AgentCreateContract({super.key, required this.model, this.workplaceModel, this.districtModel});

  @override
  State<AgentCreateContract> createState() => _AgentCreateContractState();
}

class _AgentCreateContractState extends State<AgentCreateContract> {
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  int agentId = 0;

  List<MedicineModel> preparation = [];
  LanguageModel location = LanguageModel(uz: "", ru: "", en: "");
  int locationId = 0;
  String workplace = "";
  int workplaceId = 0;
  LanguageModel special = LanguageModel(uz: "", ru: "", en: "");
  String level = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    location = LanguageModel(
        uz: widget.districtModel?.nameUzLatin ?? "",
        ru: widget.districtModel?.nameRussian ?? "",
        en: widget.districtModel?.name ?? "");
    workplace = widget.workplaceModel?.name ?? "";
    special = LanguageModel(
        uz: widget.model.fieldName ?? "",
        ru: widget.model.fieldName ?? "",
        en: widget.model.fieldName ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        shadowColor: Colors.black38,
        title: Text("Create contract"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Назад",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: Dimens.space18,
                    fontWeight: FontWeight.w500),
              )),
          SizedBox(
            width: Dimens.space10,
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Dimens.space10,
            children: [
              Container(
                padding: EdgeInsets.all(Dimens.space20),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimens.space20)),
                child: Column(
                  spacing: Dimens.space10,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Text(
                    //   "Регион",
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w600, fontSize: Dimens.space18),
                    // ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20,
                          vertical: Dimens.space16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space10),
                          color: AppColors.backgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dataTranslate(ctx: context, model: location)),
                          Icon(
                            CupertinoIcons.chevron_down,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20,
                          vertical: Dimens.space16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space10),
                          color: AppColors.backgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              workplace.isEmpty ? "Место работы" : workplace),
                          Icon(
                            CupertinoIcons.chevron_down,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20,
                          vertical: Dimens.space16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space10),
                          color: AppColors.backgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dataTranslate(ctx: context, model: special)),
                          Icon(
                            CupertinoIcons.chevron_down,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20,
                          vertical: Dimens.space16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space10),
                          color: AppColors.backgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${widget.model.firstName} ${widget.model.lastName}"),
                          Icon(
                            CupertinoIcons.chevron_down,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimens.space10,
              ),
              Container(
                padding: EdgeInsets.all(Dimens.space20),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimens.space20)),
                child: Column(
                  spacing: Dimens.space10,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Пакет",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: Dimens.space18),
                    ),
                    GestureDetector(
                      onTap: () {
                        showMedicine(
                            ctx: context,
                            medicine: preparation,
                            model: (MedicineModel value) {
                              Navigator.pop(context);
                              showInputAmount(
                                  name: value.name ?? "",
                                  amount: 1,
                                  onChange: (v) {
                                    preparation.add(value);
                                    preparation.last.quantity = v;
                                    if (formKey.currentState!.validate()) {}
                                    setState(() {});
                                  });
                            });
                      },
                      child: AppTextField(
                        textColor: Colors.black,
                        validator: (value) {
                          if (preparation.isEmpty) {
                            return "----------";
                          }
                          return null;
                        },
                        controller: TextEditingController(),
                        hintText: "Выберите препарат",
                        suffixIcon: Icon(
                          CupertinoIcons.chevron_down,
                          color: Colors.black,
                        ),
                        hintColor: Colors.black87,
                        isEnabled: false,
                      ),
                    ),
                    ...List.generate(
                      preparation.length,
                      (index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.space20,
                              vertical: Dimens.space16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimens.space10),
                              color: AppColors.backgroundColor),
                          child: Row(
                            spacing: Dimens.space10,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    preparation.removeAt(index);
                                    setState(() {});
                                  },
                                  child: SvgPicture.asset(
                                    Assets.icons.delete,
                                    height: Dimens.space20,
                                    width: Dimens.space20,
                                  )),
                              Text(
                                preparation[index].name ?? "",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                              Text("${preparation[index].quantity ?? 0}"),
                              GestureDetector(
                                onTap: () {
                                  showInputAmount(
                                      name: preparation[index].name ?? "",
                                      amount: preparation[index].quantity ?? 0,
                                      onChange: (int value) {
                                        preparation[index].quantity = value;
                                        setState(() {});
                                      });
                                },
                                child: SvgPicture.asset(
                                  Assets.icons.pen,
                                  color: Colors.grey,
                                  height: Dimens.space20,
                                  width: Dimens.space20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(Dimens.space20),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(Dimens.space20)),
                  child: Column(
                    spacing: Dimens.space10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Пакет",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimens.space18),
                      ),
                      GestureDetector(
                        onTap: () {
                          DateTime max = DateTime(2050);
                          if (toDateController.text.length == 10) {
                            DateFormat format = DateFormat("yyyy-MM-dd");
                            max = format.parse(toDateController.text.toString());
                            max.add(Duration(hours: 12));
                          }
                          showDatePickerBottomSheet(
                            ctx: context,
                            text: fromDateController.text.trim(),
                            onChange: (value) {
                              setState(() {
                                fromDateController.text = value;
                              });
                            },
                            min: DateTime.now(),
                            max: max,
                            from: true,
                          );
                        },
                        child: AppTextField(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          isEnabled: false,
                          title: "Boshlanish vaqti",
                          titleStyle: TextStyle(
                              fontSize: Dimens.space14,
                              fontWeight: FontWeight.bold),
                          controller: fromDateController,
                          hintText: "2020-10-05",
                          suffixIcon: SvgPicture.asset(
                            Assets.icons.calendar,
                            height: Dimens.space14,
                            width: Dimens.space14,
                          ).paddingAll(value: Dimens.space10),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          DateTime min = DateTime.now().add(Duration(days: 1));
                          if (fromDateController.text.length == 10) {
                            DateFormat format = DateFormat("yyyy-MM-dd");
                            min =
                                format.parse(fromDateController.text.toString());
                            min.add(Duration(hours: 12));
                          }
                          showDatePickerBottomSheet(
                            ctx: context,
                            text: toDateController.text.trim(),
                            onChange: (value) {
                              setState(() {
                                toDateController.text = value;
                              });
                            },
                            min: min,
                            max: DateTime(2050),
                            from: false,
                          );
                        },
                        child: AppTextField(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          isEnabled: false,
                          title: "tugash vaqti",
                          titleStyle: TextStyle(
                              fontSize: Dimens.space14,
                              fontWeight: FontWeight.bold),
                          controller: toDateController,
                          hintText: "2020-10-05",
                          suffixIcon: SvgPicture.asset(
                            Assets.icons.calendar,
                            height: Dimens.space14,
                            width: Dimens.space14,
                          ).paddingAll(value: Dimens.space10),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(Dimens.space20),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimens.space20)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.space20, vertical: Dimens.space16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.space10),
                      color: AppColors.backgroundColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Шаги"),
                      Text("1 200 000"),
                    ],
                  ),
                ),
              ),
              SizedBox(),
              BlocBuilder<AgentHomeCubit, AgentHomeState>(
                builder: (context, state) {
                  if (state is AgentHomeSuccess) {
                    return UniversalButton.filled(
                      cornerRadius: Dimens.space20,
                      text: "Зарегистрировать врача",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // context.read<AddDoctorCubit>().addDoctor(
                          //     doctor: DoctorModel(
                          //         firstName: names[0],
                          //         lastName: names[0],
                          //         middleName: "",
                          //         email: emailController.text.trim(),
                          //         role: "DOCTOR",
                          //         password: passwordController.text.trim(),
                          //         phoneNumber: numberController.text
                          //             .trim()
                          //             .replaceAll(" ", ""),
                          //         phonePrefix: "998",
                          //         number:
                          //         "998${numberController.text.trim().replaceAll(" ", "")}",
                          //         workPlaceId: workplaceId,
                          //         birthDate: "2000-01-01",
                          //         gender: "MALE",
                          //         fieldName: special.toUpperCase(),
                          //         position: level,
                          //         districtId: locationId),
                          //     contract: AddContractModel(
                          //         doctorId: "",
                          //         startDate:
                          //         fromDateController.text.toString(),
                          //         endDate: toDateController.text.toString(),
                          //         agentId: "",
                          //         agentContractId: state.model.id ?? 0,
                          //         medicinesWithQuantities: List.generate(
                          //           preparation.length,
                          //               (index) {
                          //             return MedicinesWithQuantity(
                          //                 medicineId:
                          //                 preparation[index].id ?? 0,
                          //                 quote:
                          //                 preparation[index].quantity ??
                          //                     0);
                          //           },
                          //         )));
                          context.read<EditContractCubit>().addContract(
                              model: AddContractModel(
                                  doctorId: '',
                                  startDate: '',
                                  endDate: '',
                                  agentId: '',
                                  contractType: '',
                                  agentContractId: 0,
                                  medicinesWithQuantities: List.generate(
                                    preparation.length,
                                    (index) {
                                      return MedicinesWithQuantity(
                                          medicineId: preparation[index].id ?? 0,
                                          quote:
                                              preparation[index].quantity ?? 0);
                                    },
                                  )),
                              doctorId: "");
                        }
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(
                height: Dimens.space20,
              ),
            ],
          ).paddingAll(value: Dimens.space20),
        ),
      ),
    );
  }

  void showInputAmount(
      {required String name,
      required int amount,
      required ValueChanged<int> onChange}) async {
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
                keyboardType: TextInputType.numberWithOptions(decimal: false),
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
                    int number =
                        int.tryParse(textController.text.toString()) ?? 1;
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

  Future<void> showDatePickerBottomSheet(
      {required BuildContext ctx,
      required String text,
      required ValueChanged<String> onChange,
      required DateTime min,
      required DateTime max,
      required bool from}) async {
    DateTime dateTime = DateTime.now().add(Duration(hours: 1));
    if (!from) {
      dateTime = min.add(Duration(hours: 5));
    }
    if (text.length == 10) {
      DateFormat format = DateFormat("yyyy-MM-dd");
      dateTime = format.parse(text.toString());
      dateTime.add(Duration(hours: 12));
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
              const Text(
                "Выберите дату",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime: dateTime,
                  maximumDate: from ? max : DateTime(2050),
                  minimumDate: from
                      ? DateTime(DateTime.now().year, DateTime.now().month,
                          DateTime.now().day)
                      : min,
                  onDateTimeChanged: (DateTime newDate) {
                    dateTime = newDate;
                  },
                ),
              ),
              CupertinoButton(
                child: const Text(
                  "Готово",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  setState(() {
                    text = DateFormat('yyyy-MM-dd').format(dateTime);
                    onChange(text);
                  });
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
}
