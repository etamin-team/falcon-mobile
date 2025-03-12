import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/cubit/contract_details_cubit.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/presentation/cubit/edit_contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/presentation/page/agent_edit_contract.dart';

import '../../../../../core/utils/dependencies_injection.dart';
import '../../../../../core/widgets/export.dart';
import '../../../edit_contract/presentation/page/agent_create_contract.dart';

class ContractDetails extends StatefulWidget {
  final String id;
  final int? contractId;

  const ContractDetails({super.key, required this.id, this.contractId});

  @override
  State<ContractDetails> createState() => _ContractDetailsState();
}

class _ContractDetailsState extends State<ContractDetails> {
  @override
  void initState() {
    context.read<ContractDetailsCubit>().getDoctorData(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContractDetailsCubit, ContractDetailsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ContractDetailsSuccess) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              toolbarHeight: Dimens.space100,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.model.firstName ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimens.space30,
                        color: AppColors.blueColor),
                  ),
                  Text(state.model.lastName ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimens.space30)),
                ],
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: Dimens.space20),
                  height: Dimens.space60,
                  width: Dimens.space60,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    Assets.images.profileImage.path,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
              child: Column(
                spacing: Dimens.space10,
                children: [
                  SizedBox(
                    height: Dimens.space20,
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimens.space16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(Dimens.space20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: Dimens.space10,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.space20,
                              vertical: Dimens.space16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.workplaceModel?.name ?? "Место работы",
                                style: TextStyle(fontSize: Dimens.space14),
                              ),
                              Icon(
                                CupertinoIcons.chevron_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.space20,
                              vertical: Dimens.space16),
                          child: Text(
                            state.model.fieldName ?? "Специальность",
                            style: TextStyle(fontSize: Dimens.space14),
                          ),
                        ),
                        Text(
                          "Контактные данные врача",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimens.space18),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.space20,
                              vertical: Dimens.space16),
                          child: Text(
                            "+${state.model.phoneNumber ?? "998 90 123 45 67"}",
                            style: TextStyle(fontSize: Dimens.space14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(Dimens.space16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(Dimens.space20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.blueColor,
                          borderRadius: BorderRadius.circular(Dimens.space10)),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20, vertical: Dimens.space16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Условие работы:",
                            style: TextStyle(
                                fontSize: Dimens.space14,
                                color: AppColors.white),
                          ),
                          Text(
                            "СУ",
                            style: TextStyle(
                                fontSize: Dimens.space14,
                                color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.profileModel != null)
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space20)),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: Dimens.space8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Заключение договоров",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ...List.generate(
                            state.profileModel?.contractedMedicineWithQuantity
                                    .length ??
                                0,
                            (index) => _buildDoctorProgress(
                                state
                                        .profileModel
                                        ?.contractedMedicineWithQuantity[index]
                                        .medicine
                                        .name ??
                                    "",
                                state
                                        .profileModel
                                        ?.contractedMedicineWithQuantity[index]
                                        .contractMedicineAmount
                                        .amount ??
                                    0,
                                state
                                        .profileModel
                                        ?.contractedMedicineWithQuantity[index]
                                        .quote ??
                                    0),
                          ),
                          // _buildDoctorProgress("Алтикам", 12, 20),
                          // _buildDoctorProgress("Амлипин", 100, 100),
                          // _buildDoctorProgress("Артокол мазь", 11, 13),
                          // _buildDoctorProgress("Артокол уколы", 44, 80),
                        ],
                      ),
                    ),
                  if (state.outContractModel != null &&
                      state.outContractModel!.outOfContractMedicineAmount
                          .isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space20)),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: Dimens.space8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Прописано вне пакета",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ...List.generate(
                            state.outContractModel?.outOfContractMedicineAmount
                                    .length ??
                                0,
                            (index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.space10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.space20,
                                    vertical: Dimens.space16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state
                                              .outContractModel
                                              ?.outOfContractMedicineAmount[
                                                  index]
                                              .medicine
                                              .name ??
                                          "",
                                      style:
                                          TextStyle(fontSize: Dimens.space14),
                                    ),
                                    Text(
                                      "${state.outContractModel?.outOfContractMedicineAmount[index].amount ?? 0}",
                                      style:
                                          TextStyle(fontSize: Dimens.space14),
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
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20)),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: Dimens.space8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Цель:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: Dimens.space10,
                            ),
                            Text(
                              "Шаг: 1.740.000",
                            ),
                          ],
                        ),
                        _buildDoctorProgress("Алтикам", 12, 20),
                      ],
                    ),
                  ),
                  UniversalButton.filled(
                    fontSize: Dimens.space14,
                    cornerRadius: Dimens.space20,
                    text: "добавить препарат",
                    onPressed: () {

                      // if(state.profileModel==null){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) =>
                                      sl<EditContractCubit>(),
                                  child: AgentCreateContract(model: state.model,districtModel: state.districtModel,workplaceModel: state.workplaceModel,),
                                )));
                      // }else{
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => BlocProvider(
                      //             create: (context) =>
                      //                 sl<EditContractCubit>(),
                      //             child: AgentEditContract(
                      //               contractId: state.profileModel?.id??0,
                      //               model: state.model,
                      //               doctorStatsModel: state.doctorStatsModel,
                      //               outContractModel: state.outContractModel,
                      //               profileModel: state.profileModel,
                      //               workplaceModel: state.workplaceModel,
                      //               districtModel: state.districtModel,
                      //             ),
                      //           )));
                      // }

                    },
                  ),
                  SizedBox(
                    height: Dimens.space20,
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildDoctorProgress(String title, int current, int total) {
    double percentage = current / total;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            width: percentage * 200, // Progressni to'g'ri belgilash
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: Dimens.space14, fontWeight: FontWeight.bold)),
                Text("$current из $total",
                    style: TextStyle(
                        fontSize: Dimens.space14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
