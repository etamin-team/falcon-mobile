import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/core/utils/data_translate.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/data/model/edit_model.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/data/model/edit_upload_model.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/presentation/cubit/edit_contract_cubit.dart';
import 'package:wm_doctor/features/medicine/presentation/cubit/medicine_cubit.dart';

import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/dependencies_injection.dart';
import '../../../../../core/widgets/export.dart';
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
  LanguageModel location = LanguageModel(uz: "", ru: "", en: "");
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



  @override
  void initState() {
    location = LanguageModel(
        uz: widget.districtModel?.nameUzLatin ?? "",
        ru: widget.districtModel?.nameRussian ?? "",
        en: widget.districtModel?.name ?? "");
    workplace = widget.workplaceModel?.name ?? "";
    selectedContractType = "KZ";
    special = LanguageModel(
        uz: widget.model.fieldName ?? "",
        ru: widget.model.fieldName ?? "",
        en: widget.model.fieldName ?? "");
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
              selled: widget
                      .profileModel
                      ?.medicineWithQuantityDoctorDTOS[index]
                      .contractMedicineDoctorAmount
                      .amount ??
                  0);
        },
      );
    }
    medicineRepositoryImpl = sl<MedicineRepositoryImpl>(); // initialize it here
    loadMedicines();
    super.initState();
  }

  void loadMedicines() async {
    final result = await medicineRepositoryImpl.getMedicine();
    result.fold(
          (failure) {
        // Handle the failure case here if needed
        print('Error: ${failure.errorMsg}');
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
        title: Text(
          "Изменить договор",
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.space24),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Назад",
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
          if(state is EditContractSuccess){
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if(state is EditContractLoading){
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
                              medicine: preparations,
                              model: (MedicineModel value1) {
                                Navigator.pop(context);
                                showInputAmount(
                                  name: value1.name ?? "",
                                  amount: 1,
                                  onChange: (v) {
                                    print("----------------------->${value1.name}" );
                                    print("----------------------->${amountController.text}" );
                                    selectedPreparations.add(value1);

                                    quantity.add(int.parse(amountController.text.toString()));
                                    preparations.last.quantity = v;
                                    calculate();
                                    setState(() {});
                                  },
                                  min: 1
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.space20,
                              vertical: Dimens.space16),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10),
                              color: AppColors.backgroundColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Выберите препарат"),
                              Icon(CupertinoIcons.chevron_down)
                            ],
                          ),
                        ),
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
                                if (medicine[index].selled == 0)
                                  GestureDetector(
                                      onTap: () {
                                        medicine.removeAt(index);
                                        setState(() {});
                                      },
                                      child: SvgPicture.asset(
                                          Assets.icons.delete)),
                                Expanded(
                                  child: Text(
                                    //TODO
                                    // (selectedPreparations[index].name!.length>27?selectedPreparations[index].name?.substring(0,27):selectedPreparations[index].name) ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    medicine[index].name ?? "",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text("${medicine[index].quantity}"),
                                GestureDetector(
                                  onTap: () {
                                    showInputAmount(
                                        name: medicine[index].name ?? "",
                                        amount: medicine[index].quantity ?? 0,
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
                      )
                    ],
                  ),
                ),

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
                        Text("$allQuote"),
                      ],
                    ),
                  ),
                ),
                UniversalButton.filled(
                  cornerRadius: Dimens.space20,
                  text: "Предложить договор",
                  onPressed: () async {
                    String token =
                        await SecureStorage().read(key: "accessToken") ?? "";
                    Map<String, dynamic> decodedToken =
                        JwtDecoder.decode(token);
                    String uuid = decodedToken["sub"];
                    context.read<EditContractCubit>().updateContract(
                            model: EditUploadModel(
                          id: widget.contractId ?? 0,
                          doctorId: widget.model.userId ?? "",
                          goalStatus: "PENDING_REVIEW",
                          createdAt: DateTime.parse(
                                  widget.profileModel?.createdAt ??
                                      "2000-01-01") ??
                              DateTime.now(),
                          startDate: DateTime.parse(
                                  widget.profileModel?.startDate ??
                                      "2000-01-01") ??
                              DateTime.now(),
                          endDate: DateTime.parse(
                                  widget.profileModel?.endDate ??
                                      "2000-01-01") ??
                              DateTime.now().add(Duration(days: 1)),
                          agentId: uuid,
                          agentContractId: widget.profileModel?.agentId ?? 0,
                          managerId: uuid,
                          medicinesWithQuantities: List.generate(
                            medicine.length,
                            (index) {
                              return MedicinesWithQuantity(
                                  medicineId: medicine[index].id,
                                  quote: medicine[index].quantity,
                                  agentContractId:
                                      widget.profileModel?.agentId ?? 0,
                                  contractMedicineDoctorAmount:
                                      ContractMedicineAmountEdit(
                                          id: medicine[index].id,
                                          amount: medicine[index].selled));
                            },
                          ),
                        ));
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
      required int min,}) async {
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
                    return "kamida $min ta bo'lishi kerak";
                  }
                  int number = int.tryParse(value.toString()) ?? 0;
                  if (number < min) {
                    return "Введённое значение меньше или равно предыдущему значению. $min";
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
