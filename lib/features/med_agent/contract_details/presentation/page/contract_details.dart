import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/cubit/contract_details_cubit.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/presentation/cubit/edit_contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/presentation/page/agent_edit_contract.dart';

import '../../../../../core/utils/dependencies_injection.dart';
import '../../../../../core/widgets/export.dart';
import '../../../../create_template/data/model/medicine_model.dart';
import '../../../../medicine/data/repository/medicine_repository_impl.dart';
import '../../../../medicine/presentation/page/medicine_dialog.dart';
import '../../../../profile/data/model/profile_data_model.dart';
import '../../../edit_contract/presentation/page/agent_create_contract.dart';

class ContractDetails extends StatefulWidget {
  final String id;
  final int? contractId;

  const ContractDetails({super.key, required this.id, this.contractId});

  @override
  State<ContractDetails> createState() => _ContractDetailsState();
}

class _ContractDetailsState extends State<ContractDetails> {
  List<MedicineModel> preparations = [];
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final recipeController = TextEditingController();
  String selectedContractType = "KZ";

  late final MedicineRepositoryImpl medicineRepositoryImpl;
  List<MedicineModel> selectedPreparations = [];


  List<int> quantity = [];
  double allQuote = 0;
  double allAmount=0;

  @override
  void initState() {
    context.read<ContractDetailsCubit>().getDoctorData(id: widget.id);
    super.initState();
    medicineRepositoryImpl = sl<MedicineRepositoryImpl>(); // initialize it here
    loadMedicines();
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
    return BlocConsumer<ContractDetailsCubit, ContractDetailsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ContractDetailsSuccess) {
          calculateAmount(state);
          calculateQuote(state);
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
                                "Место работы:",
                                style: TextStyle(fontSize: Dimens.space14),
                              ),
                              Text(
                                state.workplaceModel?.name ?? "Место работы",
                                style: TextStyle(fontSize: Dimens.space14),
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
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Место работы:",
                              style: TextStyle(fontSize: Dimens.space14),
                            ),
                            Text(
                              state.model.fieldName ?? "Специальность",
                              style: TextStyle(fontSize: Dimens.space14),
                            ),
                          ],
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
                            "+998 ${state.model.phoneNumber ?? "998 90 123 45 67"}",
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
                            state
                                .profileModel
                                ?.contractType
                                 ??
                                "",
                            style: TextStyle(
                                fontSize: Dimens.space14,
                                color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.profileModel != null)
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: AppColors.white,
                    //       borderRadius: BorderRadius.circular(Dimens.space20)),
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Column(
                    //     spacing: Dimens.space8,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // const Text(
                    //       //   "Заключение договоров",
                    //       //   style: TextStyle(
                    //       //       fontSize: 18, fontWeight: FontWeight.bold),
                    //       // ),
                    //       // ...List.generate(
                    //       //   state.profileModel?.medicineWithQuantityDoctorDTOS
                    //       //           .length ??
                    //       //       0,
                    //       //   (index) => _buildDoctorProgress(
                    //       //       state
                    //       //               .profileModel
                    //       //               ?.medicineWithQuantityDoctorDTOS[index]
                    //       //               .medicine
                    //       //               .name ??
                    //       //           "",
                    //       //       state
                    //       //               .profileModel
                    //       //               ?.medicineWithQuantityDoctorDTOS[index]
                    //       //               .contractMedicineAmount
                    //       //               .amount ??
                    //       //           0,
                    //       //       state
                    //       //               .profileModel
                    //       //               ?.medicineWithQuantityDoctorDTOS[index]
                    //       //               .quote ??
                    //       //           0),
                    //       // ),
                    //       // _buildDoctorProgress("Алтикам", 12, 20),
                    //       // _buildDoctorProgress("Амлипин", 100, 100),
                    //       // _buildDoctorProgress("Артокол мазь", 11, 13),
                    //       // _buildDoctorProgress("Артокол уколы", 44, 80),
                    //     ],
                    //   ),
                    // ),
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
                                    Expanded(
                                      child: Text(
                                        //TODO
                                        // (selectedPreparations[index].name!.length>27?selectedPreparations[index].name?.substring(0,27):selectedPreparations[index].name) ?? "",
                                        overflow: TextOverflow.ellipsis,
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
                                    ),
                                    Text(
                                      "${state.outContractModel?.outOfContractMedicineAmount[index].amount}",
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
                              allAmount.toString()+" / "+allQuote.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ...List.generate(
                          state.profileModel?.medicineWithQuantityDoctorDTOS
                              .length ??
                              0,
                              (index) => _buildDoctorProgress(
                              state
                                  .profileModel
                                  ?.medicineWithQuantityDoctorDTOS[index]
                                  .medicine
                                  .name ??
                                  "",
                              state
                                  .profileModel
                                  ?.medicineWithQuantityDoctorDTOS[index]
                                  ?.contractMedicineDoctorAmount
                                  ?.amount ??
                                  0,
                              state
                                  .profileModel
                                  ?.medicineWithQuantityDoctorDTOS[index]
                                  ?.quote ??
                                  0),
                        ),

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
                          Text(allQuote.toString()),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: Dimens.space10,
                  ),
                  UniversalButton.filled(
                    fontSize: Dimens.space14,
                    cornerRadius: Dimens.space20,
                    text: "Изменить договор",
                    onPressed: () {
                      Navigator.pop(context);
                      if(state.profileModel!=null){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) =>
                                      sl<EditContractCubit>(),
                                  child: AgentEditContract(
                                    contractId: state.profileModel?.id??0,
                                    model: state.model,
                                    doctorStatsModel: state.doctorStatsModel,
                                    outContractModel: state.outContractModel,
                                    profileModel: state.profileModel,
                                    workplaceModel: state.workplaceModel,
                                    districtModel: state.districtModel,
                                  ),
                                )));
                      }
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
                Expanded(
                  child: Text(
                    //TODO
                    // (selectedPreparations[index].name!.length>27?selectedPreparations[index].name?.substring(0,27):selectedPreparations[index].name) ?? "",
                    overflow: TextOverflow.ellipsis,
                    title ?? "",
                style: TextStyle(
                    fontSize: Dimens.space14, fontWeight: FontWeight.bold)
                  ),
                ),
                SizedBox(width: 18,),
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

  void calculateAmount(state) {

    int i=0;
    for (ContractedMedicineWithQuantity context in  state?.profileModel?.medicineWithQuantityDoctorDTOS) {

      double ball = 0;
      switch (state
          .profileModel
          ?.contractType) {
        case 'RECIPE':
          ball = context?.medicine.prescription ?? 0;
          break;
        case 'SU':
          ball = (context?.medicine.suBall ?? 0).toDouble();
          break;
        case 'SB':
          ball = (context?.medicine.sbBall ?? 0).toDouble();
          break;
        case 'GZ':
          ball = (context?.medicine.gzBall ?? 0).toDouble();
          break;
        case 'KZ':
          ball = (context?.medicine.kbBall ?? 0).toDouble();
          break;
        default:
          ball = 0;
      }
      print("22222222222222222joooooopppppppp---------------------------");

      print("BALL_$ball");
      print("AAAAAAAAAAAAAAAA:"+i.toString());
      print(context.medicine.name);
      print("context?.contractMedicineDoctorAmount.amount");

      print(context?.contractMedicineDoctorAmount);
      print("context?.contractMedicineDoctorAmount.amount");
      allAmount +=  context.contractMedicineDoctorAmount.amount * ball;
      i++;
      print("BBBBBBBBBBBBBBBBBBBBBBBBBBBB:"+i.toString());

    }
  }

  void calculateQuote(state) {
    print("joooooopppppppp---------------------------");

    int i=0;
    for (ContractedMedicineWithQuantity context in  state?.profileModel?.medicineWithQuantityDoctorDTOS) {
      print("333333333333333joooooopppppppp---------------------------");

      double ball = 0;
      switch (state
          .profileModel
          ?.contractType) {
        case 'RECIPE':
          ball = context?.medicine.prescription ?? 0;
          break;
        case 'SU':
          ball = (context?.medicine.suBall ?? 0).toDouble();
          break;
        case 'SB':
          ball = (context?.medicine.sbBall ?? 0).toDouble();
          break;
        case 'GZ':
          ball = (context?.medicine.gzBall ?? 0).toDouble();
          break;
        case 'KZ':
          ball = (context?.medicine.kbBall ?? 0).toDouble();
          break;
        default:
          ball = 0;
      }
      print("22222222222222222joooooopppppppp---------------------------");

      print("BALL_$ball");
      print("AAAAAAAAAAAAAAAA:"+i.toString());
      print(context.medicine.name);
      print("context?.contractMedicineDoctorAmount.amount");

      print(context?.contractMedicineDoctorAmount);
      print("context?.contractMedicineDoctorAmount.amount");
      allQuote +=  context.quote * ball;
      i++;
      print("BBBBBBBBBBBBBBBBBBBBBBBBBBBB:"+i.toString());

    }
    print("ALLQUOTE::: $allQuote");
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