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

import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/widgets/export.dart';
import '../../../../auth/sign_up/data/model/workplace_model.dart';
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
  List<EditContractModel> medicine = [];
  LanguageModel location = LanguageModel(uz: "", ru: "", en: "");
  int locationId = 0;
  String workplace = "";
  int workplaceId = 0;
  LanguageModel special = LanguageModel(uz: "", ru: "", en: "");

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
    if (widget.profileModel != null) {
      medicine = List.generate(
        widget.profileModel?.contractedMedicineWithQuantity.length ?? 0,
        (index) {
          return EditContractModel(
              name: widget.profileModel?.contractedMedicineWithQuantity[index]
                      .medicine.name ??
                  "",
              id: widget.profileModel?.contractedMedicineWithQuantity[index]
                      .medicine.id ??
                  0,
              quantity: widget.profileModel
                      ?.contractedMedicineWithQuantity[index].quote ??
                  0,
              selled: widget
                      .profileModel
                      ?.contractedMedicineWithQuantity[index]
                      .contractMedicineAmount
                      .amount ??
                  0);
        },
      );
    }

    super.initState();
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
                              medicine: List.generate(
                                medicine.length,
                                (index) =>
                                    MedicineModel(id: medicine[index].id),
                              ),
                              model: (MedicineModel value) {
                                Navigator.pop(context);

                                showInputAmount(
                                  name: value.name ?? "",
                                  amount: 1,
                                  onChange: (v) {
                                    medicine.add(EditContractModel(
                                        name: value.name ?? "",
                                        id: value.id ?? 0,
                                        quantity: 0,
                                        selled: 0));
                                    medicine.last.quantity = v;

                                    setState(() {});
                                  },
                                  min: 1,
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
                                Text(
                                  medicine[index].name,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                Text(medicine[index].quantity.toString()),
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
                        Text("1 200 000"),
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
                                  contractMedicineAmount:
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
      required int min,
      required ValueChanged<int> onChange}) async {
    if (min == 0) {
      min = 1;
    }
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
                  if (number < min) {
                    return "$min bo'lmasligi kerak";
                  }
                  return null;
                },
                maxLen: 5,
                controller: textController,
                hintText: "$min",
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
}
