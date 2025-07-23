import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/home/presentation/page/HomePage.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/data/model/edit_model.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/data/model/edit_upload_model.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/presentation/cubit/edit_contract_cubit.dart';
import '../../../../../core/utils/dependencies_injection.dart';
import '../../../../../core/widgets/export.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../../../../auth/sign_up/data/model/workplace_model.dart';
import '../../../../medicine/data/repository/medicine_repository_impl.dart';
import '../../../../medicine/presentation/page/medicine_dialog.dart';
import '../../../../profile/data/model/out_contract_model.dart';
import '../../../../profile/data/model/profile_data_model.dart';
import '../../../../profile/data/model/statistics_model.dart';
import '../../../../regions/data/model/district_model.dart';
import '../../../home/data/model/doctors_model.dart';

class AgentEditContract extends StatefulWidget {
  final int? contractId;
  final DoctorsModel model;
  final ProfileDataModel? profileModel;
  final WorkplaceModel? workplaceModel;
  final DoctorStatsModel? doctorStatsModel;
  final OutContractModel? outContractModel;
  final DistrictModel? districtModel;

  const AgentEditContract(
      {super.key,
      this.profileModel,
      this.workplaceModel,
      this.contractId,
      this.doctorStatsModel,
      this.outContractModel,
      required this.model,
      this.districtModel});

  @override
  State<AgentEditContract> createState() => _AgentEditContractState();
}

class _AgentEditContractState extends State<AgentEditContract> {
  // LanguageModel location = LanguageModel(uz: "", ru: "");
  LanguageModel location = LanguageModel(uz: "", ru: "", en: "");
  // LanguageModel special = LanguageModel(uz: "", ru: "");
  LanguageModel special = LanguageModel(uz: "", ru: "", en: "");
  int locationId = 0;
  int workplaceId = 0;
  String selectedContractType = "KZ";

  late MedicineRepositoryImpl medicineRepositoryImpl;
  List<EditContractModel> medicine = [];
  List<MedicineModel> medicines = [];
  List<MedicineModel> selectedPreparations = [];
  List<MedicineModel> preparations = [];

  String workplace = "";
  final amountController = TextEditingController();
  final recipeController = TextEditingController();
  List<int> quantity = [];
  double allQuote = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    location = LanguageModel(
        uz: widget.districtModel?.nameUzLatin ?? "",
        ru: widget.districtModel?.nameRussian ?? "",
        en: widget.districtModel?.name ?? ""
    );
    workplace = widget.workplaceModel?.name ?? "";
    selectedContractType = "KZ";
    special = LanguageModel(
        uz: widget.model.fieldName ?? "",
        ru: widget.model.fieldName ?? "",
        en: widget.model.fieldName ?? ""
    );
    if (widget.profileModel != null) {
      medicine = List.generate(
        widget.profileModel?.medicineWithQuantityDoctorDTOS.length ?? 0,
        (index) {
          return EditContractModel(
              name: widget.profileModel?.medicineWithQuantityDoctorDTOS[index]
                      .medicine.name ??
                  "",
              id: widget.profileModel?.medicineWithQuantityDoctorDTOS[index]
                      .medicine.id ??
                  0,
              quantity: widget.profileModel
                      ?.medicineWithQuantityDoctorDTOS[index].quote ??
                  0,
              selled: widget.profileModel?.medicineWithQuantityDoctorDTOS[index]
                      .contractMedicineDoctorAmount.amount ??
                  0);
        },
      );
    }
    medicineRepositoryImpl = sl<MedicineRepositoryImpl>(); // initialize it here
    loadMedicines();
    super.initState();
  }

  Future<void> loadMedicines() async {
    final result = await medicineRepositoryImpl.getMedicine();
    result.fold(
      (failure) {
        if (kDebugMode) {
          print('Error: ${failure.errorMsg}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load medicines: ${failure.errorMsg}')),
        );
      },
      (list) {
        setState(() {
          preparations = list;
          _updateSelectedPreparations();
        });
      },
    );
  }

  void _updateSelectedPreparations() {
    if (preparations.isNotEmpty && selectedPreparations.isNotEmpty) {
      final updatedPreparations = <MedicineModel>[];
      final updatedQuantities = <int>[];
      for (var selected in selectedPreparations) {
        final matchingMedicine = preparations.firstWhere(
          (medicine) => medicine.id == selected.id,
          orElse: () => selected,
        );
        updatedPreparations.add(matchingMedicine);
        updatedQuantities.add(quantity[selectedPreparations.indexOf(selected)]);
      }
      setState(() {
        selectedPreparations = updatedPreparations;
        quantity = updatedQuantities;
        calculate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.med_add_doctor_edit_contract.tr(),
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.space24),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                LocaleKeys.med_add_doctor_back.tr(),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Dimens.space18,
                    color: Colors.blueAccent),
              )),
          SizedBox(
            width: Dimens.space10,
          ),
        ],
      ),
      body: BlocConsumer<EditContractCubit, EditContractState>(
        listener: (context, state) {
          if (state is EditContractSuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is EditContractLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
            child: Column(
              spacing: Dimens.space20,
              children: [
                SizedBox(),
                Container(
                  padding: EdgeInsets.all(Dimens.space20),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(Dimens.space20)),
                  child: Column(
                    spacing: Dimens.space10,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.backgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                LocaleKeys.med_add_doctor_select_region_hint.tr() + ": ",
                                style: TextStyle(
                                    fontSize: Dimens.space14,
                                    fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                                " ${widget.districtModel?.name ?? 'Noma\'lum'}"),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.backgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.med_add_doctor_select_workplace_hint.tr() + ": ",
                              style: TextStyle(
                                  fontSize: Dimens.space14,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                                " ${widget.workplaceModel?.name ?? 'Noma\'lum'}"),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.backgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.med_add_doctor_select_speciality_hint.tr() + ": ",
                              style: TextStyle(
                                  fontSize: Dimens.space14,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${widget.model.fieldName?.toString() ?? 'Noma\'lum'}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.backgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.med_add_doctor_name_of_doctor.tr() + ": ",
                              style: TextStyle(
                                  fontSize: Dimens.space14,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${widget.model.firstName} ${widget.model.lastName}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                      Text(
                        LocaleKeys.med_add_doctor_edit_old_packs.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimens.space18),
                      ),
                      ...List.generate(
                        medicine.length,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    medicine[index].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text("${medicine[index].quantity}"),
                                GestureDetector(
                                  onTap: () {
                                    showInputAmount(
                                        name: medicine[index].name,
                                        amount: medicine[index].quantity,
                                        onChange: (int value) {
                                          medicine[index].quantity = value;
                                          setState(() {});
                                        },
                                        min: medicine[index].selled);
                                  },
                                  child: SvgPicture.asset(
                                    Assets.icons.pen,
                                    color: Colors.grey,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              LocaleKeys.med_add_doctor_add_new_packs.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (preparations.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("No Data Found")),
                                  );
                                  return;
                                }
                                showMedicine(
                                  ctx: context,
                                  medicine: preparations,
                                  model: (MedicineModel value) {
                                    Navigator.pop(context);
                                    showInputAmount(
                                      name: value.name ?? "",
                                      amount: 1,
                                      onChange: (v) {
                                        selectedPreparations.add(value);
                                        preparations.remove(value);
                                        quantity.add(
                                            int.parse(amountController.text));
                                        preparations.last.quantity = v;
                                        calculate();
                                        setState(() {});
                                      },
                                      min: 1,
                                    );
                                  },
                                );
                              },
                              child: AppTextField(
                                textColor: Colors.black,
                                controller: recipeController,
                                hintText: LocaleKeys.med_add_doctor_select_pack.tr(),
                                suffixIcon: const Icon(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.backgroundColor,
                                  ),
                                  child: Row(
                                    spacing: 10,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPreparations
                                                .removeAt(index);
                                            quantity.removeAt(index);
                                            calculate();
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          Assets.icons.delete,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          selectedPreparations[index].name ??
                                              "",
                                          style: const TextStyle(
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
                                              setState(() {
                                                quantity[index] = value;
                                                calculate();
                                              });
                                            },
                                            min: 1,
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          Assets.icons.pen,
                                          color: Colors.grey,
                                          height: 20,
                                          width: 20,
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
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.backgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( LocaleKeys.med_add_doctor_step.tr()),
                        Text(allQuote.toStringAsFixed(2)),
                      ],
                    ),
                  ),
                ),
                UniversalButton.filled(
                  cornerRadius: 20,
                  text:  LocaleKeys.med_add_doctor_offer_contract.tr(),
                  onPressed: () {
                    context.read<EditContractCubit>().updateContract(
                          model: EditUploadModel(
                            id: widget.contractId ?? 0,
                            medicinesWithQuantities: List.generate(
                              selectedPreparations.length,
                              (index) => MedicinesWithQuantity(
                                medicineId: selectedPreparations[index].id ?? 0,
                                quote: quantity[index],
                                agentContractId:
                                    widget.profileModel?.agentId ?? 0,
                                contractMedicineDoctorAmount:
                                    ContractMedicineAmountEdit(
                                  id: selectedPreparations[index].id ?? 0,
                                  amount: quantity[index],
                                ),
                              ),
                            ),
                          ),
                        );
                    CupertinoAlertDialog(
                      title: Text(LocaleKeys.home_delete_attention.tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimens.space18)),
                      content: Text(
                        LocaleKeys.home_exit_attention_text.tr(),
                        style: TextStyle(fontSize: Dimens.space16),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(
                            LocaleKeys.home_cancel.tr(),
                            style: TextStyle(fontSize: Dimens.space14),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Dialogni yopish
                          },
                        ),
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: Text(
                            LocaleKeys.home_exit.tr(),
                            style: TextStyle(
                                fontSize: Dimens.space14, color: Colors.red),
                          ),
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: Dimens.space20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showInputAmount(
      {required String name,
      required int amount,
      required ValueChanged<int> onChange,
      required min}) {
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
            spacing: 20,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppTextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                validator: (value) {
                  final number = int.tryParse(value!);
                  if (value.isEmpty || number! < 1) {
                    return "Kamida $min ta bo'lishi kerak";
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
                  final number = int.parse(amountController.text);
                  onChange(number);
                  Navigator.pop(context);
                },
                fontSize: 14,
                cornerRadius: 20,
              ),
              const SizedBox(height: 50),
            ],
          ).paddingOnly(
            left: 30,
            right: 30,
            top: 20,
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
        );
      },
    );
  }

  void calculate() {
    print("asasas++++ ${selectedContractType}");
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

      print("BALL_$ball");

      allQuote += quantity[i] * ball;
      i++;
    }
    print("ALLQUOTE::: $allQuote");
    setState(() {});
  }
}
