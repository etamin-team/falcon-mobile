import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/core/utils/data_translate.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/entity/regison_entity.dart';
import 'package:wm_doctor/features/profile/domain/utility/profile_utility.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_data/profile_data_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/statistics/statistics_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/widget/profile_card.dart';
import 'package:wm_doctor/features/regions/presentation/page/regions_dialog.dart';
import 'package:wm_doctor/features/reset_password/presentation/page/reset_password.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../auth/sign_up/presentation/widgets/language.dart';
import '../cubit/out_contract/out_contract_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ProfileUtility {
  // LanguageModel placeName = LanguageModel(uz: "", ru: "", en: "");
  LanguageModel placeName = LanguageModel(uz: "", ru: "");
  // LanguageModel doctorType = LanguageModel(uz: "", ru: "", en: "");
  LanguageModel doctorType = LanguageModel(uz: "", ru: "");
  bool showData = false;

  @override
  void initState() {

    context.read<ProfileCubit>().getUserData();
    context.read<ProfileDataCubit>().getProfileData();
    context.read<StatisticsCubit>().getStatistics();
    context.read<OutContractCubit>().getOutContract();
    super.initState();
  }
  Future<void> _onRefresh() async {
    // Reset placeName and doctorType to ensure fresh data
    setState(() {
      placeName = LanguageModel(uz: "", ru: "");
      // placeName = LanguageModel(uz: "", ru: "", en: "");
      doctorType = LanguageModel(uz: "", ru: "",);
      // doctorType = LanguageModel(uz: "", ru: "", en: "");
    });

    // Call the data-fetching methods
    try {
      await Future.wait([
        context.read<ProfileCubit>().getUserData(),
        context.read<ProfileDataCubit>().getProfileData(),
        context.read<StatisticsCubit>().getStatistics(),
        context.read<OutContractCubit>().getOutContract(),
      ]);
    } catch (e) {
      if (kDebugMode) {
        print('Error during refresh: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ProfileSuccess) {
          if (placeName.uz == "") {
            placeName = LanguageModel(
                uz: state.districtModel?.nameUzLatin ?? "",
                ru: state.districtModel?.nameRussian ?? "",
                // en: state.districtModel?.name ?? ""
            );
          }
          if (doctorType.uz == "") {
            doctorType = findDoctorType(name: state.model.fieldName ?? "");
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              appBar: AppBar(
                forceMaterialTransparency: true,
                toolbarHeight: 100,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.model.firstName ?? "",
                      style: TextStyle(
                          fontFamily: 'VelaSans',
                          fontWeight: FontWeight.w800,
                          fontSize: Dimens.space24,
                          color: Colors.blueAccent),
                    ),
                    Text(
                      state.model.lastName ?? "",
                      style: TextStyle(
                          fontFamily: 'VelaSans',
                          fontWeight: FontWeight.w800,
                          fontSize: Dimens.space24,
                          color: Colors.black),
                    ),
                  ],
                ).paddingOnly(left: Dimens.space10),
                actions: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(Dimens.space20),
                      height: Dimens.space70,
                      width: Dimens.space70,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade200),
                      child: Image.asset(Assets.images.profileImage.path),
                    ),
                  )
                ],
              ),
              body: BlocConsumer<ProfileDataCubit, ProfileDataState>(
                listener: (context, profileData) {

                  if (profileData is ProfileDataSuccess) {}
                },
                builder: (context, profileData) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: Dimens.space10,
                      children: [
                        BlocBuilder<StatisticsCubit, StatisticsState>(
                          builder: (context, state) {
                            if (state is StatisticsSuccess) {
                              return Container(
                                padding: EdgeInsets.all(Dimens.space20),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(Dimens.space20),
                                    color: AppColors.white),
                                child: Column(
                                  children: [
                                    Row(
                                      spacing: Dimens.space10,
                                      children: [
                                        SvgPicture.asset(Assets.icons.graph),
                                        Text(
                                          LocaleKeys.profile_statistic.tr(),
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
                                          borderRadius: BorderRadius.circular(
                                              Dimens.space10)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        spacing: Dimens.space10,
                                        children: [
                                          Text(
                                            LocaleKeys.profile_patient_served
                                                .tr(),
                                            style: TextStyle(
                                                fontFamily: 'VelaSans',
                                                fontSize: Dimens.space14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "${state.model.recipesCreatedThisMonth}",
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
                                          borderRadius: BorderRadius.circular(
                                              Dimens.space10)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        spacing: Dimens.space10,
                                        children: [
                                          Text(
                                            LocaleKeys.profile_monthly_patient
                                                .tr()
                                                .tr(),
                                            style: TextStyle(
                                                fontFamily: 'VelaSans',
                                                fontSize: Dimens.space14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "±${state.model.averageRecipesPerMonth?.round()}",
                                            style: TextStyle(
                                                fontFamily: 'VelaSans',
                                                fontSize: Dimens.space14,
                                                fontWeight: FontWeight.w400),
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
                        if (profileData is ProfileDataSuccess)
                          UniversalButton.filled(
                            text: showData
                                ? LocaleKeys.profile_hide_myPaket.tr()
                                : LocaleKeys.profile_show_myPaket.tr(),
                            onPressed: () {
                              setState(() {
                                showData = !showData;
                              });
                            },
                            cornerRadius: Dimens.space20,
                            fontSize: Dimens.space14,
                          ),
                        SizedBox(),
                        if (showData && profileData is ProfileDataSuccess)
                          ProfileCard(
                            model: profileData.model,
                          ),
                        BlocConsumer<OutContractCubit, OutContractState>(
                          listener: (context, state) {
                          },
                          builder: (context, outState) {
                            if (outState is OutContractSuccess) {
                              if (outState
                                  .model.outOfContractMedicineAmount.isNotEmpty) {
                                return Container(
                                  padding: EdgeInsets.all(Dimens.space20),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(Dimens.space20),
                                      color: AppColors.white),
                                  child: Column(
                                    spacing: Dimens.space10,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LocaleKeys.profile_prescribed_paket.tr(),
                                        style: TextStyle(
                                            fontFamily: 'VelaSans',
                                            fontSize: Dimens.space18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      ...List.generate(
                                        outState.model.outOfContractMedicineAmount
                                            .length,
                                            (index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.backgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    Dimens.space10)),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimens.space20,
                                                  vertical: Dimens.space14),
                                              decoration: BoxDecoration(
                                                  color:
                                                  AppColors.backgroundColor,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.space10)),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      maxLines: 2,
                                                      overflow: TextOverflow.fade,
                                                      outState
                                                          .model
                                                          .outOfContractMedicineAmount[index]
                                                          .medicine
                                                          .name ??
                                                          "",
                                                      style: TextStyle(
                                                          fontFamily: 'VelaSans',
                                                          fontSize: Dimens.space14,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Text(outState
                                                      .model
                                                      .outOfContractMedicineAmount[
                                                  index]
                                                      .amount
                                                      .toString()),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }

                            return SizedBox();
                          },
                        ),
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
                                    LocaleKeys.profile_profile_data.tr(),
                                    style: TextStyle(
                                        fontFamily: "VelaSans",
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
                                child: Text(
                                  formatDate(DateTime.parse(
                                      state.model.dateOfBirth ??
                                          DateTime.now().toString())),
                                  style: TextStyle(
                                      fontFamily: "VelaSans",
                                      fontSize: Dimens.space14,
                                      fontWeight: FontWeight.w400),
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
                                child: Text(
                                  formatPhoneNumber(state.model.number),
                                  style: TextStyle(
                                      fontFamily: "VelaSans",
                                      fontSize: Dimens.space14,
                                      fontWeight: FontWeight.w400),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  spacing: Dimens.space10,
                                  children: [
                                    Text(
                                      dataTranslate(
                                          ctx: context, model: placeName),
                                      style: TextStyle(
                                          fontFamily: "VelaSans",
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
                                              title: Text(LocaleKeys
                                                  .profile_address_updated
                                                  .tr()),
                                              autoCloseDuration:
                                              const Duration(seconds: 3),
                                              showProgressBar: false,
                                              primaryColor: Colors.white,
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                            );
                                            setState(() {
                                              placeName = value;
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.space14,
                                    vertical: Dimens.space16),
                                decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius:
                                    BorderRadius.circular(Dimens.space10)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  spacing: Dimens.space10,
                                  children: [
                                    Text(
                                      LocaleKeys.profile_job_title.tr(),
                                      style: TextStyle(
                                          fontFamily: "VelaSans",
                                          fontSize: Dimens.space14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      dataTranslate(ctx: context, model: doctorType),
                                      style: TextStyle(
                                          fontFamily: "VelaSans",
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  spacing: Dimens.space10,
                                  children: [
                                    Text(
                                      LocaleKeys.profile_workplace.tr(),
                                      style: TextStyle(
                                          fontFamily: "VelaSans",
                                          fontSize: Dimens.space14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      state.workplaceModel?.name.toString() ?? "",
                                      style: TextStyle(
                                          fontFamily: "VelaSans",
                                          fontSize: Dimens.space14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dimens.space10,
                              ),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    spacing: Dimens.space10,
                                    children: [
                                      Text(
                                        LocaleKeys.profile_password.tr(),
                                        style: TextStyle(
                                            fontFamily: "VelaSans",
                                            fontSize: Dimens.space14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        LocaleKeys.profile_reset_password.tr(),
                                        style: TextStyle(
                                            fontFamily: "VelaSans",
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    spacing: Dimens.space10,
                                    children: [
                                      Text(
                                        LocaleKeys.profile_language.tr(),
                                        style: TextStyle(
                                            fontFamily: "VelaSans",
                                            fontSize: Dimens.space14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        dataTranslate(
                                            ctx: context,
                                            model: LanguageModel(
                                                uz: "O'zbekcha",
                                                ru: "Русский",
                                                // en: "English"
                                            )),
                                        style: TextStyle(
                                            fontFamily: "VelaSans",
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
                            padding:
                            EdgeInsets.symmetric(vertical: Dimens.space16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(Dimens.space16),
                                color: Colors.red),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: Dimens.space10,
                              children: [
                                SvgPicture.asset(Assets.icons.logOut),
                                Text(
                                  LocaleKeys.profile_log_out.tr(),
                                  style: TextStyle(
                                      fontFamily: "VelaSans",
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: Dimens.space20),
                  );
                },
              ),
            ),
          );
        }
        if (state is ProfileError) {
          return Scaffold(
            body: Center(
              child: Column(
                spacing: Dimens.space20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.profile_profile_error.tr(),
                    style: TextStyle(
                        fontSize: Dimens.space14, fontWeight: FontWeight.w500),
                  ),
                  UniversalButton.outline(
                    height: 50,
                    width: 200,
                    text: LocaleKeys.profile_refresh.tr(),
                    onPressed: () {
                      context.read<ProfileCubit>().getUserData();
                    },
                  )
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
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