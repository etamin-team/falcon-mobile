import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/utility/doctor_level.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/utility/doctor_type.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/add_contract_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/doctor_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/presentation/cubit/add_doctor_cubit.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_dialog.dart';
import 'package:wm_doctor/features/regions/presentation/page/regions_dialog.dart';
import 'package:wm_doctor/features/workplace/presentation/page/workplace_dialog.dart';

import '../../../../../core/utils/text_mask.dart';
import '../../../../../core/widgets/export.dart';
import '../../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../contract/presentation/cubit/contract_cubit.dart';
import '../../../home/presentation/cubit/agent_home_cubit.dart';
import '../../../home/presentation/cubit/doctor/doctor_cubit.dart';
import '../../../profile/presentation/cubit/agent_profile_data/agent_profile_data_cubit.dart';

class AgentAddDoctor extends StatefulWidget {
  const AgentAddDoctor({super.key});

  @override
  State<AgentAddDoctor> createState() => _AgentAddDoctorState();
}

class _AgentAddDoctorState extends State<AgentAddDoctor> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final workplaceController = TextEditingController();
  final doctorTypeController = TextEditingController();
  final doctorLevelController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final recipeController = TextEditingController();
  int agentId = 0;

  List<MedicineModel> preparation = [];
  LanguageModel location = LanguageModel(uz: "", ru: "", en: "");
  int locationId = 0;
  String workplace = "";
  int workplaceId = 0;
  int agentContractId = 1;
  String special = "";
  String level = "";
  final formKey = GlobalKey<FormState>();
  List<String> contractTypesList = ["KZ", "SU", "SB", "GZ"," RECIPE"];
  final List<bool> _isSelected = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text("Добавить врача",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: Dimens.space28)),
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
      body: BlocConsumer<AddDoctorCubit, AddDoctorState>(
        listener: (context, state) {
          if (state is AddDoctorSuccess) {
            print("success bo'ldi =================");
            context.read<AgentHomeCubit>().getData();
            context.read<DoctorCubit>().getDoctors();
            context.read<ContractCubit>().getContracts();
            context.read<ProfileCubit>().getUserData();
            context.read<AgentProfileDataCubit>().getProfileData();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is AddDoctorLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: Dimens.space10,
                children: [
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
                        AppTextField(
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Введите имя и фамилию врача.";
                              }
                              return null;
                            },
                            controller: nameController,
                            hintText: "Ф.И.О. врача"),
                        GestureDetector(
                          onTap: () {
                            showRegions(
                              ctx: context,
                              onChange: (value) {
                                addressController.text = value.uz;
                                if (formKey.currentState!.validate()) {}
                              },
                              districtId: (value) {
                                locationId = value;
                              },
                            );
                          },
                          child: AppTextField(
                            textColor: Colors.black,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            controller: addressController,
                            hintText: "Район",
                            suffixIcon: Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.black,
                            ),
                            hintColor: Colors.black87,
                            isEnabled: false,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showWorkplaceDialog(
                                ctx: context,
                                name: (String value) {
                                  workplaceController.text = value;
                                  if (formKey.currentState!.validate()) {}
                                },
                                id: (int value) {
                                  workplaceId = value;
                                });
                          },
                          child: AppTextField(
                            textColor: Colors.black,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            controller: workplaceController,
                            hintText: "Место работы",
                            suffixIcon: Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.black,
                            ),
                            hintColor: Colors.black87,
                            isEnabled: false,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDoctorTypeList(
                              ctx: context,
                              onchange: (value) {
                                doctorTypeController.text = value.uz;
                                special = value.en;
                                if (formKey.currentState!.validate()) {}
                              },
                              realType: (value) {},
                            );
                          },
                          child: AppTextField(
                            textColor: Colors.black,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            controller: doctorTypeController,
                            hintText: "Специальность",
                            suffixIcon: Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.black,
                            ),
                            hintColor: Colors.black87,
                            isEnabled: false,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDoctorPositionList(
                              ctx: context,
                              onchange: (value) {
                                doctorLevelController.text = value.uz;
                                level = value.uz;
                                if (formKey.currentState!.validate()) {}
                              },
                            );
                          },
                          child: AppTextField(
                            textColor: Colors.black,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            controller: doctorLevelController,
                            hintText: "Должность",
                            suffixIcon: Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.black,
                            ),
                            hintColor: Colors.black87,
                            isEnabled: false,
                          ),
                        ),
                        SizedBox(),
                        Text(
                          "Контактные данные врача",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimens.space18),
                        ),
                        AppTextField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              String pattern =
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(value.toString()) && value.toString().isNotEmpty) {
                                return "Email to'g'ri kriiting";
                              }

                              return null;
                            },
                            controller: emailController,
                            hintText: "Почта (muhim emas)"),
                        AppTextField(
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "---------";
                              }
                              return null;
                            },
                            prefixIcon: Text("+998 "),
                            formatter: [
                              TextMask(pallet: '## ### ## ##'),
                              LengthLimitingTextInputFormatter(12),
                            ],
                            controller: numberController,
                            hintText: "90 123 45 67"),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                        Text(
                          "Временный пароль",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimens.space18),
                        ),
                        AppTextField(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "---------";
                            }
                            return null;
                          },
                          controller: passwordController,
                          hintText: "********",
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: Dimens.space10,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    passwordController.text =
                                        generatePassword();
                                    setState(() {});
                                  },
                                  child: SvgPicture.asset(Assets.icons.repeat)),
                              GestureDetector(
                                  onTap: () {
                                    if (passwordController.text.isNotEmpty) {
                                      Clipboard.setData(ClipboardData(
                                          text: passwordController.text));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Скопировано'),
                                        duration: Duration(seconds: 1),
                                      ));
                                    }
                                  },
                                  child: SvgPicture.asset(Assets.icons.copy)),
                              SizedBox(
                                width: Dimens.space5,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimens.space10,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Пакет",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimens.space18),
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
                                    },
                                  );
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
                            controller: recipeController,
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
                                  borderRadius:
                                  BorderRadius.circular(Dimens.space10),
                                  color: AppColors.backgroundColor),
                              child: Row(
                                spacing: Dimens.space10,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Text("${preparation[index].quantity ?? 0}"),
                                  GestureDetector(
                                    onTap: () {
                                      showInputAmount(
                                          name: preparation[index].name ?? "",
                                          amount:
                                          preparation[index].quantity ?? 0,
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
                            "Условия пакета",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimens.space18),
                          ),
                          GestureDetector(
                            onTap: () {
                              DateTime max = DateTime(2050);
                              if (toDateController.text.length == 10) {
                                DateFormat format = DateFormat("yyyy-MM-dd");
                                max = format
                                    .parse(toDateController.text.toString());
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
                              title: "Дата начала",
                              titleStyle: TextStyle(
                                  fontSize: Dimens.space14,
                                  fontWeight: FontWeight.bold),
                              controller: fromDateController,
                              hintText: "2025-09-05",
                              textColor: Colors.black,
                              suffixIcon: SvgPicture.asset(
                                Assets.icons.calendar,
                                height: Dimens.space14,
                                width: Dimens.space14,
                              ).paddingAll(value: Dimens.space10),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              DateTime min =
                              DateTime.now().add(Duration(days: 1));
                              if (fromDateController.text.length == 10) {
                                DateFormat format = DateFormat("yyyy-MM-dd");
                                min = format
                                    .parse(fromDateController.text.toString());
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
                              title: "Дата окончания",
                              titleStyle: TextStyle(
                                  fontSize: Dimens.space14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              controller: toDateController,
                              hintText: "2025-10-05",
                              textColor: Colors.black,
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
                        return UniversalButton.filled(
                          cornerRadius: Dimens.space20,
                          text: "Зарегистрировать врача",
                          onPressed: () {
                            final names = nameController.text.split(" ");
                            context.read<AddDoctorCubit>().addDoctor(
                                doctor: DoctorModel(
                                    firstName: names[0],
                                    lastName:
                                    names.length > 1 ? names[1] : "",
                                    middleName:
                                    names.length > 2 ? names[2] : "",
                                    email: emailController.text.trim(),
                                    role: "DOCTOR",
                                    password: passwordController.text.trim(),
                                    phoneNumber: numberController.text
                                        .trim()
                                        .replaceAll(" ", ""),
                                    phonePrefix: "998",
                                    number:
                                    "998${numberController.text.trim().replaceAll(" ", "")}",
                                    workPlaceId: workplaceId,
                                    birthDate: "2000-01-01",
                                    gender: "MALE",
                                    fieldName: special.toUpperCase(),
                                    position: level,
                                    districtId: locationId),
                                contract: AddContractModel(
                                    doctorId: "",
                                    startDate: fromDateController.text.toString(),
                                    endDate: toDateController.text.toString(),
                                    agentId: "",
                                    contractType: "KZ",
                                    agentContractId: agentContractId ?? 0,
                                    medicinesWithQuantities: List.generate(
                                      preparation.length,
                                          (index) {
                                        return MedicinesWithQuantity(
                                            medicineId:
                                            preparation[index].id ?? 0,
                                            quote:
                                            preparation[index].quantity ??
                                                0);
                                      },
                                    )));
                          agentContractId ++;
                            },
                        );
                    },
                  ),
                  SizedBox(
                    height: Dimens.space20,
                  ),
                ],
              ),
            ),
          );
        },
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

  String generatePassword() {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();

    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}