
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/create_template/presentation/page/create_template.dart';
import 'package:wm_doctor/features/preparad/presentation/page/preparad.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_cubit.dart';

import '../../../../gen/locale_keys.g.dart';
import '../../../template/presentation/page/template.dart';
import '../../../template/presentation/page/template_page2.dart';
import '../../data/model/template_model.dart';
import '../cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context
        .read<HomeCubit>()
        .getTemplate(saved: "", sortBy: "", searchText: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
                    LocaleKeys.home_greeting.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Dimens.space22,
                        color: Colors.black),
                  ),
                  Text(
                    state.model.firstName??"",
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
                  LocaleKeys.home_greeting.tr(),
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w800,
                      fontSize: Dimens.space24,
                      color: Colors.black),
                ),
              ],
            );
          },
        ),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeGetTemplateError) {
          }
        },
        builder: (context, state) {
          if (state is HomeGetTemplateSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<HomeCubit>()
                    .getTemplate(saved: "", sortBy: "", searchText: "");
              },
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreparadPage()));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimens.space20),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space20)),
                      child: Column(
                        spacing: Dimens.space10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(Assets.icons.jar),
                          Text(
                            LocaleKeys.home_preparation.tr(),
                            style: TextStyle(
                              fontFamily: 'VelaSans',
                                fontWeight: FontWeight.w700,
                                fontSize: Dimens.space14),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.space20,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimens.space20),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space20)),
                      child: Scrollbar(
                        child: Column(
                          spacing: Dimens.space10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: Dimens.space10,
                              children: [
                                SvgPicture.asset(Assets.icons.folder),
                                Text(
                                  LocaleKeys.home_template.tr(),
                                  style: TextStyle(
                                    fontFamily: 'VelaSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: Dimens.space18),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TemplatePage(onChange: (TemplateModel value) {  },)));

                                  },
                                  child: Text(
                                    LocaleKeys.home_all.tr(),
                                    style: TextStyle(
                                      fontFamily: 'VelaSans',
                                        fontWeight: FontWeight.w600,
                                        fontSize: Dimens.space16,
                                        color: AppColors.blueColor),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: state.list.isEmpty?Center(child: Text("no data"),):Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      spacing: Dimens.space10,
                                      children: List.generate(
                                        state.list.length,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => TemplatePage2(
                                                        model: state.list[index],
                                                      )));
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.all(Dimens.space16),
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColors.backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.list[index].name??"",
                                                    style: TextStyle(
                                                      fontFamily: 'VelaSans',
                                                        fontSize: Dimens.space14,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            AppColors.redAccent),
                                                  ),
                                                  Row(
                                                    spacing: Dimens.space5,
                                                    children: [
                                                      Text(
                                                        LocaleKeys.home_dose.tr(),
                                                        style:
                                                            TextStyle(
                                                              fontFamily: 'VelaSans',
                                                                fontSize: Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      Text(
                                                        state
                                                            .list[index]
                                                            .preparations?[0]
                                                            .amount??"",
                                                        style:
                                                            TextStyle(
                                                              fontFamily: 'VelaSans',
                                                                fontSize: Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    spacing: Dimens.space5,
                                                    children: [
                                                      Text(
                                                        LocaleKeys.home_type.tr(),
                                                        style:
                                                            TextStyle(
                                                              fontFamily: 'VelaSans',
                                                                fontSize: Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      Text(
                                                        state.list[index]
                                                            .preparations?[0].type??"",
                                                        style:
                                                            TextStyle(
                                                              fontFamily: 'VelaSans',
                                                                fontSize: Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    spacing: Dimens.space5,
                                                    children: [
                                                      Text(
                                                        LocaleKeys.home_note.tr(),
                                                        style:
                                                            TextStyle(
                                                              fontFamily: 'VelaSans',
                                                                fontSize: Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          state.list[index]
                                                              .diagnosis??"",
                                                          style:
                                                              TextStyle(
                                                                fontFamily: 'VelaSans',
                                                                  fontSize: Dimens
                                                                      .space12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    height: 150,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white.withOpacity(0),
                                              // Yengil xira
                                              Colors.white.withOpacity(0.6),
                                              // Yengil xira
                                              Colors.white.withOpacity(0.9),
                                              // Qattiq xira
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: UniversalButton.filled(
                      width: 200,
                      height: Dimens.space50,
                      fontSize: Dimens.space14,
                      cornerRadius: Dimens.space16,
                      text: LocaleKeys.home_create_template.tr(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateTemplate()));
                      },
                    ),
                  ).paddingAll(value: Dimens.space10)
                ],
              ).paddingSymmetric(horizontal: Dimens.space20),
            );
          }
          if (state is HomeGetTemplateError) {
            return Center(
              child: Column(
                spacing: Dimens.space20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.home_home_error.tr(),
                    style: TextStyle(
                        fontSize: Dimens.space14, fontWeight: FontWeight.w500),
                  ),
                  UniversalButton.outline(
                    height: 50,
                    width: 200,
                    text: LocaleKeys.home_refresh.tr(),
                    onPressed: () {
                      context
                          .read<HomeCubit>()
                          .getTemplate(saved: "", sortBy: "", searchText: "");
                    },
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
