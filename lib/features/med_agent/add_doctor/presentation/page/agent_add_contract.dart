import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/add_contract_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/doctor_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/presentation/cubit/add_doctor_cubit.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_dialog.dart';
import 'package:wm_doctor/core/utils/dependencies_injection.dart';
import 'package:wm_doctor/core/utils/text_mask.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/medicine/data/repository/medicine_repository_impl.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract/presentation/cubit/contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/agent_home_cubit.dart';
import 'package:wm_doctor/features/med_agent/profile/presentation/cubit/agent_profile_data/agent_profile_data_cubit.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../../regions/presentation/cubit/regions_cubit.dart';
import 'doctors_dialog.dart';

class AgentAddContract extends StatefulWidget {
  const AgentAddContract({super.key});

  @override
  State<AgentAddContract> createState() => _AgentAddContractState();
}

class _AgentAddContractState extends State<AgentAddContract> {
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
  final amountController = TextEditingController();
  double allQuote = 0;

  late final MedicineRepositoryImpl medicineRepositoryImpl;

  int agentId = 0;

  List<MedicineModel> preparations = [];
  List<MedicineModel> selectedPreparations = [];
  List<int> quantity = [];
  // LanguageModel location = LanguageModel(uz: "", ru: "", );
  LanguageModel location = LanguageModel(uz: "", ru: "", en: "");
  int locationId = 0;
  int workplaceId = 0;
  String doctorID = "";
  int agentContractId = 1;
  bool isCreateDoctor = true;
  String locationDTO = "";
  String workplaceDTO = "";
  String special = "";
  bool remember = false;
  String level = "";
  final formKey = GlobalKey<FormState>();
  List<String> contractTypesList = ["KZ", "SU", "SB", "GZ", "RECIPE"];
  List<String> contractTypesFullList = [
    "Каб.вакцинации",
    "Спецусловия",
    "Спецбал",
    "Госзакуп",
    "Рецепт"
  ];
  String selectedContractType = "KZ";
  String selectedContractTypeFull = "Каб.вакцинации";

  @override
  void initState() {
    super.initState();
    medicineRepositoryImpl = sl<MedicineRepositoryImpl>();
    loadMedicines();
    // context.read<DoctorCubit>().getDoctorsWithFilters(districtId, workplaceId, doctorType, withContracts); // Doktorlarni yuklash
  }

  void loadMedicines() async {
    final result = await medicineRepositoryImpl.getMedicine();
    result.fold(
          (failure) {
        if (kDebugMode) {
          print('Error: ${failure.errorMsg}');
        }
      },
          (list) {
        setState(() {
          preparations = list;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text(LocaleKeys.med_add_doctor_contract_title.tr(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: Dimens.space28)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                LocaleKeys.med_add_doctor_back.tr(),
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: Dimens.space18,
                    fontWeight: FontWeight.w500),
              )),
          SizedBox(width: Dimens.space10),
        ],
      ),
      body: BlocConsumer<AddDoctorCubit, AddDoctorState>(
        listener: (context, state) {
          print("success bo'ldi =================");

          if (state is AddDoctorSuccess) {
            if (kDebugMode) {
              print("success bo'ldi =================");
            }
            context.read<AgentHomeCubit>().getData();
            context.read<ContractCubit>().getContracts();
            context.read<RegionsCubit>().getRegions();
            context.read<ProfileCubit>().getUserData();
            context.read<AgentProfileDataCubit>().getProfileData();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is AddDoctorLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: Dimens.space10,
                children: [
                  SizedBox(height: Dimens.space10),
                  Container(
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20)),
                    child: Column(
                      spacing: Dimens.space10,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDoctor(
                              ctx: context,
                              phone: (String value) {
                                numberController.text = value;
                                if (formKey.currentState!.validate()) {}
                              },
                              type: (String value) {
                                doctorLevelController.text = value;
                                if (formKey.currentState!.validate()) {}
                              },
                              level: (String value) {
                                doctorTypeController.text = value;
                                if (formKey.currentState!.validate()) {}
                              },
                              firstName: (String value) {
                                nameController.text = value;
                                if (formKey.currentState!.validate()) {}
                              },
                              lastName: (String value) {
                                nameController.text =
                                "${nameController.text} $value";
                                if (formKey.currentState!.validate()) {}
                              },
                              id: (String value) {
                                doctorID = value;
                                isCreateDoctor = false;
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
                            controller: nameController,
                            hintText:
                            LocaleKeys.med_add_doctor_select_doctor.tr(),
                            suffixIcon: Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.black,
                            ),
                            hintColor: Colors.black87,
                            isEnabled: false,
                          ),
                        ),

                        ///place/work
                        // AppTextField(
                        //   textColor: Colors.black,
                        //   validator: (value) {
                        //     if (value.toString().isEmpty) {
                        //       return "";
                        //     }
                        //     return null;
                        //   },
                        //   controller: addressController,
                        //   hintText: "Район",
                        //   hintColor: Colors.black87,
                        //   isEnabled: false,
                        // ),
                        // AppTextField(
                        //   textColor: Colors.black,
                        //   validator: (value) {
                        //   },
                        //   controller: workplaceController,
                        //   hintText: "Место работы",
                        //   hintColor: Colors.black87,
                        //   isEnabled: false,
                        // ),
                        AppTextField(
                          textColor: Colors.black,
                          controller: doctorTypeController,
                          hintText:
                          LocaleKeys.med_add_doctor_select_speciality.tr(),
                          hintColor: Colors.black87,
                          isEnabled: false,
                        ),
                        AppTextField(
                          textColor: Colors.black,
                          controller: doctorLevelController,
                          hintText:
                          LocaleKeys.med_add_doctor_select_position.tr(),
                          hintColor: Colors.black87,
                          isEnabled: false,
                        ),
                        SizedBox(),
                        Text(
                          LocaleKeys.med_add_doctor_info_doctor.tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimens.space18),
                        ),

                        ///email
                        // AppTextField(
                        //     keyboardType: TextInputType.emailAddress,
                        //     validator: (value) {
                        //       String pattern =
                        //           r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                        //       RegExp regex = RegExp(pattern);
                        //       if (!regex.hasMatch(value.toString()) &&
                        //           value.toString().isNotEmpty) {
                        //         return "Email to'g'ri kiritilsin";
                        //       }
                        //       return null;
                        //     },
                        //     controller: emailController,
                        //     hintText: "Почта (muhim emas)"),
                        AppTextField(
                            isEnabled: false,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              return null;
                            },
                            prefixIcon: Text("+998 "),
                            formatter: [
                              TextMask(pallet: '## ### ## ##'),
                              LengthLimitingTextInputFormatter(12),
                            ],
                            controller: numberController,
                            textColor: Colors.black,
                            hintText: "90 123 45 67"),
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
                          LocaleKeys.med_add_doctor_contract_type.tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Dimens.space18),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(247, 248, 252, 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                LocaleKeys.med_add_doctor_contract_type_hint
                                    .tr(),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                              value: selectedContractTypeFull,
                              onChanged: (String? newValue) {
                                calculate();
                                setState(() {
                                  int selectedIndex =
                                  contractTypesFullList.indexOf(newValue!);
                                  selectedContractTypeFull = newValue;
                                  selectedContractType =
                                  contractTypesList[selectedIndex];
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.black, size: 30),
                              style:
                              TextStyle(fontSize: 18, color: Colors.black),
                              dropdownColor: Color.fromRGBO(247, 248, 252, 1),
                              items: contractTypesFullList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(fontSize: 16)),
                                    );
                                  }).toList(),
                            ),
                          ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.med_add_doctor_packs.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimens.space18),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  remember = !remember;
                                  print(remember);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  remember
                                      ? CupertinoIcons.bookmark_fill
                                      : CupertinoIcons.bookmark,
                                  color: remember
                                      ? CupertinoColors.activeBlue
                                      : CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (kDebugMode) {
                              print(preparations.length);
                            }
                            showMedicine(
                                ctx: context,
                                medicine: preparations,
                                model: (MedicineModel value1) {
                                  Navigator.pop(context);
                                  showInputAmount(
                                    name: value1.name ?? "",
                                    amount: 1,
                                    onChange: (v) {
                                      selectedPreparations.add(value1);
                                      preparations.remove(value1);
                                      quantity.add(
                                          int.parse(amountController.text));
                                      preparations.last.quantity = v;
                                      if (formKey.currentState!.validate()) {}
                                      calculate();
                                      setState(() {});
                                    },
                                  );
                                });
                          },
                          child: AppTextField(
                            textColor: Colors.black,
                            validator: (value) {
                              if (preparations.isEmpty) {
                                return "----------";
                              }
                              return null;
                            },
                            controller: recipeController,
                            hintText:
                            LocaleKeys.med_add_doctor_select_pack.tr(),
                            suffixIcon: Icon(
                              CupertinoIcons.add_circled_solid,
                              color: Colors.blueAccent,
                            ),
                            hintColor: Colors.black87,
                            isEnabled: false,
                          ),
                        ),
                        ...List.generate(
                          selectedPreparations.length,
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
                                        setState(() {
                                          preparations
                                              .add(selectedPreparations[index]);
                                          selectedPreparations.removeAt(index);
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        Assets.icons.delete,
                                        height: Dimens.space20,
                                        width: Dimens.space20,
                                      )),
                                  Expanded(
                                    child: Text(
                                      selectedPreparations[index].name ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text("${quantity[index]}"),
                                  GestureDetector(
                                    onTap: () {
                                      showInputAmount(
                                          name: selectedPreparations[index]
                                              .name ??
                                              "",
                                          amount: quantity[index],
                                          onChange: (int value) {
                                            quantity[index] = value;
                                            calculate();
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
                            LocaleKeys.med_add_doctor_pack_required.tr(),
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
                                return null;
                              },
                              isEnabled: false,
                              title: LocaleKeys.med_add_doctor_data_start.tr(),
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
                                return null;
                              },
                              isEnabled: false,
                              title: LocaleKeys.med_add_doctor_data_finish.tr(),
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
                          Text(LocaleKeys.med_add_doctor_step.tr()),
                          Text(allQuote.toString()),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(),
                  BlocBuilder<AgentHomeCubit, AgentHomeState>(
                    builder: (context, state) {
                      return UniversalButton.filled(
                          cornerRadius: Dimens.space20,
                          text: LocaleKeys.med_add_doctor_register.tr(),
                          onPressed: () {
                            if (nameController.text.isNotEmpty) {
                              if (selectedPreparations.length > 4) {
                                if (fromDateController.text.isNotEmpty &&
                                    toDateController.text.isNotEmpty) {
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
                                          password:
                                          passwordController.text.trim(),
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
                                        doctorId: doctorID,
                                        startDate:
                                        fromDateController.text.toString(),
                                        endDate:
                                        toDateController.text.toString(),
                                        agentId: "",
                                        contractType: selectedContractType,
                                        agentContractId: agentContractId,
                                        medicineWithQuantityDoctorDTOS:
                                        List.generate(
                                          selectedPreparations.length,
                                              (index) {
                                            return MedicineWithQuantityDoctorDTOS(
                                                medicineId:
                                                selectedPreparations[index]
                                                    .id ??
                                                    0,
                                                quote: quantity[index]);
                                          },
                                        ),
                                      ),
                                      isCreateDoctor: isCreateDoctor,
                                      doctorId: doctorID);
                                  agentContractId++;
                                  resetForm(remember);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              LocaleKeys
                                                  .med_add_doctor_success_title
                                                  .tr(),
                                              style: TextStyle(
                                                  color: Colors.greenAccent)),
                                          content: Text(
                                            LocaleKeys
                                                .med_add_doctor_success_text
                                                .tr(),
                                          ),
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              LocaleKeys
                                                  .med_add_doctor_error_title
                                                  .tr(),
                                              style: TextStyle(
                                                  color: Colors.redAccent)),
                                          content: Text(
                                            LocaleKeys.med_add_doctor_error_text
                                                .tr(),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Ок"),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            LocaleKeys
                                                .med_add_doctor_error_title
                                                .tr(),
                                            style: TextStyle(
                                                color: Colors.redAccent)),
                                        content: Text(
                                          LocaleKeys
                                              .med_add_doctor_error_text_prep
                                              .tr(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(LocaleKeys
                                                .med_add_doctor_ok
                                                .tr()),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          LocaleKeys
                                              .med_add_doctor_select_doctor
                                              .tr(),
                                          style: TextStyle(
                                              color: Colors.redAccent)),
                                      content: Text(
                                        LocaleKeys
                                            .med_add_doctor_error_text_doctor
                                            .tr(),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Ок"),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          });
                    },
                  ),
                  SizedBox(height: Dimens.space20),
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
    final quantForm = GlobalKey<FormState>();
    amountController.text = amount.toString();
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
                controller: amountController,
                hintText: "1",
              ),
              UniversalButton.filled(
                text: "Сохранять",
                onPressed: () {
                  if (quantForm.currentState!.validate()) {
                    int number =
                        int.tryParse(amountController.text.toString()) ?? 1;
                    onChange(number);
                    Navigator.pop(context);
                  }
                },
                fontSize: Dimens.space14,
                cornerRadius: Dimens.space20,
              ),
              SizedBox(height: Dimens.space50),
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
      backgroundColor: Colors.white,
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
                child: Text(
                  LocaleKeys.texts_ready.tr(),
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
              const SizedBox(height: 20),
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

  void calculate() {
    allQuote = 0;
    int i = 0;
    for (MedicineModel medicine in selectedPreparations) {
      double ball = 0;
      switch (selectedContractType) {
        case 'RECIPE':
          ball = medicine.prescription ?? 0;
          break;
        case 'SU':
          ball = (medicine.suBall ?? 0).toDouble();
          break;
        case 'SB':
          ball = (medicine.sbBall ?? 0).toDouble();
          break;
        case 'GZ':
          ball = (medicine.gzBall ?? 0).toDouble();
          break;
        case 'KZ':
          ball = (medicine.kbBall ?? 0).toDouble();
          break;
        default:
          ball = 0;
      }
      allQuote += quantity[i] * ball;
      i++;
    }
    setState(() {});
  }

  void resetForm(bool save) {
    // Clear all TextEditingControllers
    if (save) {
      nameController.clear();
      addressController.clear();
      workplaceController.clear();
      doctorTypeController.clear();
      doctorLevelController.clear();
      emailController.clear();
      numberController.clear();
      passwordController.clear();
      fromDateController.clear();
      toDateController.clear();
    } else {
      nameController.clear();
      addressController.clear();
      workplaceController.clear();
      doctorTypeController.clear();
      doctorLevelController.clear();
      emailController.clear();
      numberController.clear();
      passwordController.clear();
      fromDateController.clear();
      toDateController.clear();
      selectedPreparations = [];
      recipeController.clear();
      amountController.clear();
      loadMedicines();
    }

    // Reset numbers to their initial values
    allQuote = 0;
    agentId = 0;
    locationId = 0;
    workplaceId = 0;
    agentContractId = 1; // Initial value was 1

    // Clear lists

    // Reset custom objects and strings to their initial values
    // location = LanguageModel(uz: "", ru: "");
    location = LanguageModel(uz: "", ru: "", en: "");
    doctorID = "";
    locationDTO = "";
    workplaceDTO = "";
    special = "";
    level = "";

    // Reset boolean to its initial value
    isCreateDoctor = true;

    // Update the UI if necessary
    setState(() {});
  }
}