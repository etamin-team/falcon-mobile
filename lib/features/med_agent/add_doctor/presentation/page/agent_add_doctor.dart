import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/core/utils/dependencies_injection.dart';
import 'package:wm_doctor/core/utils/text_mask.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/utility/doctor_level.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/utility/doctor_type.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/add_contract_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/model/doctor_model.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/presentation/cubit/add_doctor_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/agent_home_cubit.dart';
import 'package:wm_doctor/features/med_agent/profile/presentation/cubit/agent_profile_data/agent_profile_data_cubit.dart';
import 'package:wm_doctor/features/medicine/data/repository/medicine_repository_impl.dart';
import 'package:wm_doctor/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_dialog.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wm_doctor/features/regions/presentation/cubit/regions_cubit.dart';
import 'package:wm_doctor/features/regions/presentation/page/regions_dialog.dart';
import 'package:wm_doctor/features/workplace/presentation/page/workplace_dialog.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../../../../auth/sign_up/data/repository/sign_up_repository_impl.dart';
import '../../../contract/presentation/cubit/contract_cubit.dart';
import '../../data/repository/add_doctor_repository_impl.dart';

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
  final amountController = TextEditingController();
  double allQuote = 0;

  late final MedicineRepositoryImpl medicineRepositoryImpl;

  int agentId = 0;
  List<MedicineModel> preparations = [];
  List<MedicineModel> selectedPreparations = [];
  List<int> quantity = [];
  LanguageModel location = LanguageModel(uz: "", ru: "", en: "");
  int locationId = 0;
  int workplaceId = 0;
  String doctorID = "";
  int agentContractId = 1;
  bool isCreateDoctor = true;
  String locationDTO = "";
  String workplaceDTO = "";
  String special = "";
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
    context.read<RegionsCubit>().getRegions();
    context.read<MedicineCubit>().getMedicine();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(
            sl<SignUpRepositoryImpl>(),
          ),
        ),
        BlocProvider<AddDoctorCubit>(
          create: (context) => AddDoctorCubit(
            sl<AddDoctorRepositoryImpl>(),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: Text(
            LocaleKeys.med_add_doctor_title.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimens.space28,
            ),
          ),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: Dimens.space10),
          ],
        ),
        body: BlocConsumer<AddDoctorCubit, AddDoctorState>(
          listener: (context, state) {
            if (state is AddDoctorSuccess) {
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
            return BlocListener<SignUpCubit, SignUpState>(
              listener: (context, signUpState) {
                if (signUpState is SignUpCheckNumberSuccess) {
                  if (!signUpState.isExist) {
                    // Proceed with doctor registration
                    final names = nameController.text.split(" ");
                    context.read<AddDoctorCubit>().addDoctor(
                      doctor: DoctorModel(
                        firstName: names[0],
                        lastName: names.length > 1 ? names[1] : "",
                        middleName: names.length > 2 ? names[2] : "",
                        email: emailController.text.trim(),
                        role: "DOCTOR",
                        password: passwordController.text.trim(),
                        phoneNumber: numberController.text.trim().replaceAll(
                            " ", ""),
                        phonePrefix: "998",
                        number: "998${numberController.text.trim().replaceAll(
                            " ", "")}",
                        workPlaceId: workplaceId,
                        birthDate: "2000-01-01",
                        gender: "MALE",
                        fieldName: special.toUpperCase(),
                        position: level,
                        districtId: locationId,
                      ),
                      contract: AddContractModel(
                        doctorId: "",
                        startDate: fromDateController.text.toString(),
                        endDate: toDateController.text.toString(),
                        agentId: "",
                        contractType: selectedContractType,
                        agentContractId: agentContractId,
                        medicineWithQuantityDoctorDTOS: List.generate(
                          selectedPreparations.length,
                              (index) =>
                              MedicineWithQuantityDoctorDTOS(
                                medicineId: selectedPreparations[index].id ?? 0,
                                quote: quantity[index],
                              ),
                        ),
                      ),
                      isCreateDoctor: true,
                      doctorId: '',
                    );
                    agentContractId++;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Успешно",
                              style: TextStyle(color: Colors.green)),
                          content: Text("Вы успешно зарегистрировали врача"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);},
                              child: Text("Ок"),
                            ),
                          ],
                        );
                      },
                    );
                    resetForm();
                  }else{
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(LocaleKeys.med_add_doctor_error_title.tr(), style: TextStyle(color: Colors.redAccent)),
                          content: Text(LocaleKeys.med_add_doctor_error_text.tr()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(LocaleKeys.med_add_doctor_ok.tr()),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: SingleChildScrollView(
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
                          borderRadius: BorderRadius.circular(Dimens.space20),
                        ),
                        child: Column(
                          spacing: Dimens.space10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return LocaleKeys.med_add_doctor_enter_name.tr();
                                }
                                return null;
                              },
                              controller: nameController,
                              hintText: LocaleKeys.med_add_doctor_hint_name.tr(),
                            ),
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
                                    return LocaleKeys.med_add_doctor_select_region.tr();
                                  }
                                  return null;
                                },
                                controller: addressController,
                                hintText: LocaleKeys.med_add_doctor_select_region_hint.tr(),
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
                                  },
                                );
                              },
                              child: AppTextField(
                                textColor: Colors.black,
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return LocaleKeys.med_add_doctor_select_workplace.tr();
                                  }
                                  return null;
                                },
                                controller: workplaceController,
                                hintText: LocaleKeys.med_add_doctor_select_workplace_hint.tr(),
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
                                    return LocaleKeys.med_add_doctor_select_speciality.tr();
                                  }
                                  return null;
                                },
                                controller: doctorTypeController,
                                hintText: LocaleKeys.med_add_doctor_select_speciality_hint.tr(),
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
                                    return LocaleKeys.med_add_doctor_select_position.tr();
                                  }
                                  return null;
                                },
                                controller: doctorLevelController,
                                hintText: LocaleKeys.med_add_doctor_select_position_hint.tr(),
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
                              LocaleKeys.med_add_doctor_info_doctor.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimens.space18,
                              ),
                            ),
                            AppTextField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                String pattern =
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                RegExp regex = RegExp(pattern);
                                if (!regex.hasMatch(value.toString()) &&
                                    value.toString().isNotEmpty) {
                                  return LocaleKeys.med_add_doctor_enter_email.tr();
                                }
                                return null;
                              },
                              controller: emailController,
                              hintText: LocaleKeys.med_add_doctor_email.tr(),
                            ),
                            AppTextField(
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return LocaleKeys.med_add_doctor_enter_number.tr();
                                }
                                return null;
                              },
                              prefixIcon: Text("+998 "),
                              formatter: [
                                TextMask(pallet: '## ### ## ##'),
                                LengthLimitingTextInputFormatter(12),
                              ],
                              controller: numberController,
                              hintText: "90 123 45 67",
                            ),
                            SizedBox(height: Dimens.space10),
                            Text(
                              LocaleKeys.med_add_doctor_temporary_password.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimens.space18,
                              ),
                            ),
                            AppTextField(
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return LocaleKeys.med_add_doctor_temporary_password_hint.tr();
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
                                      passwordController.text = generatePassword();
                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(Assets.icons.repeat),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (passwordController.text.isNotEmpty) {
                                        Clipboard.setData(
                                          ClipboardData(text: passwordController.text),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("MessageCopied"),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    },
                                    child: SvgPicture.asset(Assets.icons.copy),
                                  ),
                                  SizedBox(width: Dimens.space5),
                                ],
                              ),
                            ),
                            SizedBox(height: Dimens.space10),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Dimens.space20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space20),
                        ),
                        child: Column(
                          spacing: Dimens.space10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocaleKeys.med_add_doctor_contract_type.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimens.space18,
                              ),
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
                                    LocaleKeys.med_add_doctor_contract_type_hint.tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  value: selectedContractTypeFull,
                                  onChanged: (String? newValue) {
                                    calculate();
                                    setState(() {
                                      int selectedIndex = contractTypesFullList.indexOf(newValue!);
                                      selectedContractTypeFull = newValue;
                                      selectedContractType = contractTypesList[selectedIndex];
                                    });
                                  },
                                  icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                  dropdownColor: Color.fromRGBO(247, 248, 252, 1),
                                  items: contractTypesFullList
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: TextStyle(fontSize: 16)),
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
                          borderRadius: BorderRadius.circular(Dimens.space20),
                        ),
                        child: Column(
                          spacing: Dimens.space10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocaleKeys.med_add_doctor_packs.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimens.space18,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
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
                                        quantity.add(int.parse(amountController.text));
                                        preparations.last.quantity = v;
                                        if (formKey.currentState!.validate()) {}
                                        calculate();
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                              child: AppTextField(
                                textColor: Colors.black,
                                controller: recipeController,
                                hintText: LocaleKeys.med_add_doctor_select_pack.tr(),
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
                                    vertical: Dimens.space16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimens.space10),
                                    color: AppColors.backgroundColor,
                                  ),
                                  child: Row(
                                    spacing: Dimens.space10,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          preparations.add(selectedPreparations[index]);
                                          quantity.removeAt(index);
                                          selectedPreparations.removeAt(index);
                                          calculate();
                                          setState(() {});
                                        },
                                        child: SvgPicture.asset(
                                          Assets.icons.delete,
                                          height: Dimens.space20,
                                          width: Dimens.space20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          selectedPreparations[index].name ?? "",
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text("${quantity[index]}"),
                                      GestureDetector(
                                        onTap: () {
                                          showInputAmount(
                                            name: selectedPreparations[index].name ?? "",
                                            amount: quantity[index],
                                            onChange: (int value) {
                                              quantity[index] = value;
                                              calculate();
                                              setState(() {});
                                            },
                                          );
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
                          borderRadius: BorderRadius.circular(Dimens.space20),
                        ),
                        child: Column(
                          spacing: Dimens.space10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.med_add_doctor_pack_required.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimens.space18,
                              ),
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
                                isEnabled: false,
                                title: LocaleKeys.med_add_doctor_data_start.tr(),
                                titleStyle: TextStyle(
                                  fontSize: Dimens.space14,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                DateTime min = DateTime.now().add(Duration(days: 1));
                                if (fromDateController.text.length == 10) {
                                  DateFormat format = DateFormat("yyyy-MM-dd");
                                  min = format.parse(fromDateController.text.toString());
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
                                isEnabled: false,
                                title: LocaleKeys.med_add_doctor_data_finish.tr(),
                                titleStyle: TextStyle(
                                  fontSize: Dimens.space14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
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
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Dimens.space20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space20),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.space20,
                            vertical: Dimens.space16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.space10),
                            color: AppColors.backgroundColor,
                          ),
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
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        LocaleKeys.med_add_doctor_error_title.tr(),
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                      content: Text(LocaleKeys.med_add_doctor_error_text.tr()),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(LocaleKeys.med_add_doctor_ok.tr()),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }
                              if (numberController.text.length == 12) {
                                context.read<SignUpCubit>().checkNumber(
                                  number: "998${numberController.text.replaceAll(" ", "").replaceAll("+", "")}",
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Ошибка",
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                      content: Text("Введите номер телефона из 12 символов"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Ок"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }
                              // Additional validations moved to BlocListener
                            },
                          );
                        },
                      ),
                      SizedBox(height: Dimens.space20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showInputAmount({
    required String name,
    required int amount,
    required ValueChanged<int> onChange,
  }) async {
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
                  fontSize: Dimens.space18,
                  fontWeight: FontWeight.w500,
                ),
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
                    int number = int.tryParse(amountController.text.toString()) ?? 1;
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
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
        );
      },
    );
  }

  Future<void> showDatePickerBottomSheet({
    required BuildContext ctx,
    required String text,
    required ValueChanged<String> onChange,
    required DateTime min,
    required DateTime max,
    required bool from,
  }) async {
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
              const Text(
                "Выберите дату",
                style: TextStyle(
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
                  maximumDate: from ? max : DateTime(2050),
                  minimumDate: from
                      ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
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
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
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
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void showContractType(ValueChanged<String> onChange) {}

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

  void resetForm() {
    nameController.clear();
    // addressController.clear();
    // workplaceController.clear();
    doctorTypeController.clear();
    doctorLevelController.clear();
    emailController.clear();
    numberController.clear();
    // passwordController.clear();
    fromDateController.clear();
    toDateController.clear();
    // recipeController.clear();
    // amountController.clear();
    // allQuote = 0;
    agentId = 0;
    // locationId = 0;
    // workplaceId = 0;
    // agentContractId = 1;
    // selectedPreparations = [];
    // quantity = [];
    // location = LanguageModel(uz: "", ru: "", en: "");
    doctorID = "";
    // locationDTO = "";
    // workplaceDTO = "";
    special = "";
    level = "";
    isCreateDoctor = true;
    setState(() {});
  }
}