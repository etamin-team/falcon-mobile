import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/presentation/page/agent_add_doctor.dart';
import 'package:wm_doctor/features/med_agent/contract/presentation/page/agent_contract.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/cubit/contract_details_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/agent_home_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/doctor/doctor_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/widgets/doctors.dart';

import '../../../../../core/utils/dependencies_injection.dart';
import '../../../../../core/widgets/custom_progress_bar.dart';
import '../../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../add_doctor/presentation/cubit/add_doctor_cubit.dart';
import '../../../contract_details/presentation/page/contract_details.dart';

class AgentHomePage extends StatefulWidget {
  const AgentHomePage({super.key});

  @override
  State<AgentHomePage> createState() => _AgentHomePageState();
}

class _AgentHomePageState extends State<AgentHomePage> {
  @override
  void initState() {
    context.read<AgentHomeCubit>().getData();
    context.read<DoctorCubit>().getDoctors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSuccess) {
              return Row(
                children: [
                  Text(
                    "Здравствуйте,  ",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Dimens.space20,
                        color: Colors.black),
                  ),
                  Text(
                    state.model.firstName ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: Dimens.space22,
                        color: AppColors.blueColor),
                  ),
                ],
              );
            }
            return Row(
              children: [
                Text(
                  "Здравствуйте, ",
                  style: TextStyle(
                      fontFamily: "VelaSans",
                      fontWeight: FontWeight.w800,
                      fontSize: Dimens.space24,
                      color: Colors.black),
                ),
              ],
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
        child: Column(
          spacing: Dimens.space20,
          children: [
            SizedBox(),
            Row(
              spacing: Dimens.space10,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) => sl<AddDoctorCubit>(),
                                  child: AgentAddDoctor(),
                                )));
                  },
                  child: Container(
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Dimens.space6,
                      children: [
                        SvgPicture.asset(Assets.icons.stethoscope),
                        Text(
                          "Добавить\nврача",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimens.space16),
                        )
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AgentContract()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Dimens.space6,
                      children: [
                        SvgPicture.asset(Assets.icons.pills),
                        Text(
                          "Изменить\nдоговор",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimens.space16),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
            BlocBuilder<AgentHomeCubit, AgentHomeState>(
              builder: (context, state) {
                if (state is AgentHomeSuccess) {
                  return Container(
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.space20),
                        color: AppColors.white),
                    child: Column(
                      spacing: Dimens.space10,
                      children: [
                        Row(
                          spacing: Dimens.space10,
                          children: [
                            SvgPicture.asset(Assets.icons.list),
                            Text(
                              "Цель",
                              style: TextStyle(
                                  fontSize: Dimens.space18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        if ((state.model.fieldWithQuantityDtos?.length ?? 0) !=
                            0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.space20),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimens.space20),
                                color: AppColors.backgroundColor),
                            child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  childrenPadding:
                                      EdgeInsets.only(bottom: Dimens.space20),
                                  tilePadding: EdgeInsets.zero,
                                  title: Text(
                                    "Цель",
                                    style: TextStyle(
                                        fontSize: Dimens.space18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: List.generate(
                                    state.model.fieldWithQuantityDtos?.length ??
                                        0,
                                    (index) {
                                      return CustomProgressBar(
                                          backgroundColor: Colors.white,
                                          title: state
                                                  .model
                                                  .fieldWithQuantityDtos?[index]
                                                  .fieldName ??
                                              "-",
                                          current: state
                                                  .model
                                                  .fieldWithQuantityDtos?[index]
                                                  .contractFieldAmount
                                                  ?.amount ??
                                              0,
                                          total: state
                                                  .model
                                                  .fieldWithQuantityDtos?[index]
                                                  .quote ??
                                              0);
                                    },
                                  ),
                                )),
                          ),
                        if ((state.model.medicineAgentGoalQuantityDTOS?.length ??
                                0) !=
                            0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.space20),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimens.space20),
                                color: AppColors.backgroundColor),
                            child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  childrenPadding:
                                      EdgeInsets.only(bottom: Dimens.space20),
                                  tilePadding: EdgeInsets.zero,
                                  title: Text(
                                    "Заключение договоров",
                                    style: TextStyle(
                                        fontSize: Dimens.space18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: List.generate(
                                    state.model.medicineAgentGoalQuantityDTOS
                                            ?.length ??
                                        0,
                                    (index) {
                                      return CustomProgressBar(
                                          backgroundColor: Colors.white,
                                          title: state
                                                  .model
                                                  .medicineAgentGoalQuantityDTOS?[
                                                      index]
                                                  .medicine
                                                  ?.name ??
                                              "-",
                                          current: state
                                                  .model
                                                  .medicineAgentGoalQuantityDTOS?[
                                                      index]
                                                  .contractMedicineMedAgentAmount
                                                  ?.amount ??
                                              0,
                                          total: state
                                                  .model
                                                  .medicineAgentGoalQuantityDTOS?[index]
                                                  .quote ??
                                              0);
                                    },
                                  ),
                                )),
                          ),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            BlocBuilder<DoctorCubit, DoctorState>(
              builder: (context, state) {
                if (state is DoctorSuccess) {
                  return GestureDetector(
                    onTap: () {
                      showDoctors(ctx: context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimens.space20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space20),
                          color: AppColors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: Dimens.space10,
                        children: [
                          Row(
                            spacing: Dimens.space10,
                            children: [
                              SvgPicture.asset(Assets.icons.stars),
                              Text(
                                "Последние подключения",
                                style: TextStyle(
                                    fontSize: Dimens.space18,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          AppTextField(
                            isEnabled: false,
                              prefixIcon: Icon(CupertinoIcons.search),
                              controller: TextEditingController(),
                              hintText: "Ф.И.О, Район, ЛПУ, Специальность"),
                          ...List.generate(
                            state.list.take(5).toList().length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  print(state.list[index].userId);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                                create: (context) =>
                                                    sl<ContractDetailsCubit>(),
                                                child: ContractDetails(
                                                  id: state
                                                          .list[index].userId ??
                                                      "",
                                                ),
                                              )));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space20,
                                      vertical: Dimens.space16),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Dimens.space10),
                                      color: AppColors.backgroundColor),
                                  child: Text(
                                    "${state.list[index].firstName} ${state.list[index].middleName ?? ""} ${state.list[index].lastName ?? ""}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
