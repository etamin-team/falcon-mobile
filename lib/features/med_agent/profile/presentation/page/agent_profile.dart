
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/med_agent/profile/domain/utility/agent_profile_utility.dart';
import 'package:wm_doctor/features/med_agent/profile/presentation/cubit/agent_profile_data/agent_profile_data_cubit.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../../../core/widgets/custom_progress_bar.dart';
import '../../../../auth/sign_up/presentation/widgets/language.dart';
import '../../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../../regions/presentation/page/regions_dialog.dart';
import '../../../../reset_password/presentation/page/reset_password.dart';
import '../../../home/presentation/cubit/agent_home_cubit.dart';

class AgentProfile extends StatefulWidget {
  const AgentProfile({super.key});

  @override
  State<AgentProfile> createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile> with AgentProfileUtility {
  String placeName = "";

  @override
  void initState() {
    context.read<ProfileCubit>().getUserData();
    context.read<AgentProfileDataCubit>().getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ProfileSuccess) {
          if (placeName == "") {
            placeName = state.districtModel?.nameRussian ?? "";
          }
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
                  SizedBox(
                    height: Dimens.space5,
                  ),
                  // Text(' Ташкент   Ст. МП   III гр.   С.У.',
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold, fontSize: Dimens.space12)),
                ],
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: Dimens.space20),
                  height: Dimens.space60,
                  width: Dimens.space60,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(Assets.images.profileImage.path),
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
                                LocaleKeys.med_profile_sales_in_pack_for_last_month.tr(),
                                style: TextStyle(fontSize: Dimens.space12),
                              ),
                              Text(
                                "250 000",
                                style: TextStyle(fontSize: Dimens.space12),
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
                                LocaleKeys.med_profile_quote.tr(),
                                style: TextStyle(fontSize: Dimens.space12),
                              ),
                              Text(
                                "300 000",
                                style: TextStyle(fontSize: Dimens.space12),
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
                                LocaleKeys.med_profile_percent_completion.tr(),
                                style: TextStyle(fontSize: Dimens.space12),
                              ),
                              Text(
                                "70%",
                                style: TextStyle(fontSize: Dimens.space12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<AgentProfileDataCubit, AgentProfileDataState>(
                    builder: (context, dataState) {
                      if (dataState is AgentProfileDataSuccess) {
                        return Container(
                          padding: EdgeInsets.all(Dimens.space16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(Dimens.space20),
                          ),
                          child: Column(
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
                                  children: [
                                    Text(
                                      LocaleKeys.med_profile_connected_doctors.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      LocaleKeys.med_profile_total.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${dataState.model.allConnectedDoctors ?? 0}",
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
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
                                  children: [
                                    Text(
                                      LocaleKeys.med_profile_connected_doctors.tr(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      LocaleKeys.med_profile_for_current_month.tr(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${dataState.model.connectedDoctorsThisMonth ?? 0}",
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
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
                                  children: [
                                    Text(
                                      LocaleKeys.med_profile_connected_contracts.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      LocaleKeys.med_profile_total.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${dataState.model.allConnectedContracts ?? 0}",
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
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
                                  children: [
                                    Text(
                                      LocaleKeys.med_profile_connected_contracts.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      LocaleKeys.med_profile_for_current_month.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${dataState.model.connectedContractsThisMonth ?? 0}",
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
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
                                  children: [
                                    Text(
                                      LocaleKeys.med_profile_written_recipes.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      LocaleKeys.med_profile_total.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${dataState.model.writtenRecipesThisMonth ?? 0}",
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
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
                                  children: [
                                    Text(
                                      LocaleKeys.med_profile_written_recipes.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      LocaleKeys.med_profile_for_current_month.tr(),
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${dataState.model.writtenMedicinesThisMonth ?? 0}",
                                      style: TextStyle(
                                          fontSize: Dimens.space12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                  BlocBuilder<AgentHomeCubit, AgentHomeState>(
                      builder: (context, state) {
                    if (state is AgentHomeSuccess) {
                      return Column(
                        spacing: Dimens.space10,
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent),
                            child: ExpansionTile(
                              // tilePadding: EdgeInsets.zero,
                              title: Text(
                                "Цель",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimens.space16),
                              ),
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius:
                                      BorderRadius.circular(Dimens.space20)),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Охват врачей",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: Dimens.space8,
                                      ),
                                      ...List.generate(
                                        state.model.fieldWithQuantityDtos?.length ??
                                            0,
                                            (index) {
                                          return CustomProgressBar(
                                            // backgroundColor: Colors.white,
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
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: Dimens.space10,),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius:
                                      BorderRadius.circular(Dimens.space20)),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Заключение договоров",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      ...List.generate(
                                        state.model.medicineAgentGoalQuantityDTOS
                                            ?.length ??
                                            0,
                                            (index) {
                                          return CustomProgressBar(
                                            // backgroundColor: Colors.white,
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
                                                  .medicineAgentGoalQuantityDTOS?[
                                              index]
                                                  .quote ??
                                                  0);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),


                          ),

                        ],
                      );
                    }
                    return SizedBox();
                  }),
                  Container(
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.space20),
                        color: AppColors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          spacing: Dimens.space10,
                          children: [
                            SvgPicture.asset(Assets.icons.person),
                            Text(
                            LocaleKeys.med_profile_personal_information.tr(),
                              style: TextStyle(
                                  fontFamily: 'VelaSans',
                                  fontSize: Dimens.space18,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dimens.space20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.space14,
                              vertical: Dimens.space16),
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: Dimens.space10,
                            children: [
                              Text(
                                LocaleKeys.med_profile_birthdate.tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                formatDate(DateTime.parse(state.model.dateOfBirth ??
                                    DateTime.now().toString())),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.space14,
                              vertical: Dimens.space16),
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: Dimens.space10,
                            children: [
                              Text(
                                LocaleKeys.med_profile_phone_number.tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                formatPhoneNumber(state.model.number),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.space14,
                              vertical: Dimens.space16),
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: Dimens.space10,
                            children: [
                              Expanded(
                                child: Text(
                                  LocaleKeys.med_profile_adress.tr(),
                                  style: TextStyle(
                                      fontFamily: 'VelaSans',
                                      fontSize: Dimens.space14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                placeName,
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space14,
                                    fontWeight: FontWeight.w400),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showRegions(
                                    ctx: context,
                                    onChange: (value) {
                                      toastification.show(
                                        style: ToastificationStyle.flat,
                                        context: context,
                                        type: ToastificationType.success,
                                        alignment: Alignment.topCenter,
                                        title: Text(LocaleKeys.med_profile_adress_updated.tr(),),
                                        autoCloseDuration:
                                            const Duration(seconds: 3),
                                        showProgressBar: false,
                                        primaryColor: Colors.white,
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      );
                                      setState(() {
                                        placeName = value.uz;
                                      });
                                    },
                                    districtId: (value) {
                                      changeAddress(
                                          districtId: value,
                                          model: state.model);
                                    },
                                  );
                                },
                                child: SvgPicture.asset(
                                  Assets.icons.pen,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: Dimens.space14,
                        //       vertical: Dimens.space16),
                        //   decoration: BoxDecoration(
                        //       color: AppColors.backgroundColor,
                        //       borderRadius:
                        //           BorderRadius.circular(Dimens.space10)),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     spacing: Dimens.space10,
                        //     children: [
                        //       Text(
                        //         "Место работы:",
                        //         style: TextStyle(
                        //             fontFamily: 'VelaSans',
                        //             fontSize: Dimens.space14,
                        //             fontWeight: FontWeight.w400),
                        //       ),
                        //       Text(
                        //         state.workplaceModel?.name.toString() ?? "",
                        //         style: TextStyle(
                        //             fontFamily: 'VelaSans',
                        //             fontSize: Dimens.space14,
                        //             fontWeight: FontWeight.w400),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.space14,
                                vertical: Dimens.space16),
                            decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius:
                                    BorderRadius.circular(Dimens.space10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: Dimens.space10,
                              children: [
                                Text(
                                  LocaleKeys.med_profile_password.tr(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'VelaSans',
                                      fontSize: Dimens.space14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  LocaleKeys.med_profile_reset_password.tr(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'VelaSans',
                                      color: Colors.red,
                                      fontSize: Dimens.space14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showLanguageChoice(ctx: context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.space14,
                                vertical: Dimens.space16),
                            decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius:
                                    BorderRadius.circular(Dimens.space10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: Dimens.space10,
                              children: [
                                Text(
                                  LocaleKeys.med_profile_language.tr(),
                                  style: TextStyle(
                                      fontFamily: 'VelaSans',
                                      fontSize: Dimens.space14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  LocaleKeys.med_profile_select_language.tr(),
                                  style: TextStyle(
                                      fontFamily: 'VelaSans',
                                      color: AppColors.black,
                                      fontSize: Dimens.space14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      showLogOutDiaolog(ctx: context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: Dimens.space16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space16),
                          color: Colors.red),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: Dimens.space10,
                        children: [
                          SvgPicture.asset(Assets.icons.logOut),
                          Text(
                            LocaleKeys.med_profile_log_out.tr(),
                            style: TextStyle(
                                fontFamily: 'VelaSans',
                                color: AppColors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
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

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  String formatPhoneNumber(String phone) {
    if (phone.length == 12) {
      return "+${phone.substring(0, 3)} ${phone.substring(3, 5)} ${phone.substring(5, 8)} ${phone.substring(8, 10)} ${phone.substring(10, 12)}";
    }
    return phone; // Noto‘g‘ri format bo‘lsa, o‘zgartirmaslik
  }

}