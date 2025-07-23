import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:wm_doctor/features/create_template/presentation/page/create_template.dart';
import 'package:wm_doctor/features/home/data/model/template_model.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wm_doctor/features/template/presentation/page/templates.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';
import '../../../preparad/presentation/page/preparad.dart';
import '../cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch templates on page load
    context.read<HomeCubit>().getTemplate(saved: "", sortBy: "", searchText: "");
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
                    LocaleKeys.home_greeting.tr(),
                    style: TextStyle(
                      fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w800,
                      fontSize: Dimens.space22,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    state.model.firstName ?? "",
                    style: TextStyle(
                      fontFamily: 'VelaSans',
                      fontWeight: FontWeight.w900,
                      fontSize: Dimens.space22,
                      color: AppColors.blueColor,
                    ),
                  ),
                ],
              );
            }
            return Text(
              LocaleKeys.home_greeting.tr(),
              style: TextStyle(
                fontFamily: 'VelaSans',
                fontWeight: FontWeight.w800,
                fontSize: Dimens.space24,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeGetTemplateError) {
            // Optionally show a snackbar or toast for error feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.home_home_error.tr())),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeGetTemplateSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                // Await the template fetch to ensure refresh indicator stops
                await context.read<HomeCubit>().getTemplate(saved: "", sortBy: "", searchText: "");
              },
              color: AppColors.blueColor,
              backgroundColor: AppColors.white,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PreparadPage()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimens.space20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20),
                      ),
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
                              fontSize: Dimens.space14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.space20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimens.space20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20),
                      ),
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
                                    fontSize: Dimens.space18,
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TemplatePage(
                                          onChange: (TemplateModel value) {},
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    LocaleKeys.home_all.tr(),
                                    style: TextStyle(
                                      fontFamily: 'VelaSans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimens.space16,
                                      color: AppColors.blueColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: state.list.isEmpty
                                  ? Center(
                                child: Text(
                                  LocaleKeys.home_template_not_available
                                      .tr(),
                                ),
                              )
                                  : Stack(
                                children: [
                                  SingleChildScrollView(
                                    physics:
                                    const AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      spacing: Dimens.space10,
                                      children: List.generate(
                                        state.list.length,
                                            (index) {
                                          final template = state.list[index];
                                          final hasPreparations =
                                              template.preparations != null &&
                                                  template
                                                      .preparations!.isNotEmpty;
                                          return GestureDetector(
                                            onTap: () {
                                              // Uncomment and implement navigation to template details if needed
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => TemplatePage2(
                                              //       model: template,
                                              //     ),
                                              //   ),
                                              // );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                  Dimens.space16),
                                              decoration: BoxDecoration(
                                                color:
                                                AppColors.backgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(15),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          template.name ?? "",
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'VelaSans',
                                                            fontSize:
                                                            Dimens.space14,
                                                            fontWeight:
                                                            FontWeight.w800,
                                                            color: AppColors
                                                                .redAccent,
                                                          ),
                                                        ),
                                                        Row(
                                                          spacing:
                                                          Dimens.space5,
                                                          children: [
                                                            Text(
                                                              LocaleKeys
                                                                  .home_dose
                                                                  .tr(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'VelaSans',
                                                                fontSize:
                                                                Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              hasPreparations
                                                                  ? template
                                                                  .preparations![
                                                              0]
                                                                  .amount ??
                                                                  ""
                                                                  : "N/A",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'VelaSans',
                                                                fontSize:
                                                                Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          spacing:
                                                          Dimens.space5,
                                                          children: [
                                                            Text(
                                                              LocaleKeys
                                                                  .home_type
                                                                  .tr(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'VelaSans',
                                                                fontSize:
                                                                Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              hasPreparations
                                                                  ? template
                                                                  .preparations![
                                                              0]
                                                                  .type ??
                                                                  ""
                                                                  : "N/A",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'VelaSans',
                                                                fontSize:
                                                                Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          spacing:
                                                          Dimens.space5,
                                                          children: [
                                                            Text(
                                                              LocaleKeys
                                                                  .home_note
                                                                  .tr(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                'VelaSans',
                                                                fontSize:
                                                                Dimens
                                                                    .space12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                template
                                                                    .diagnosis ??
                                                                    "",
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                  'VelaSans',
                                                                  fontSize: Dimens
                                                                      .space12,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext ctx) {
                                                          return CupertinoAlertDialog(
                                                            title: Text(
                                                              LocaleKeys
                                                                  .home_delete_attention
                                                                  .tr(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize:
                                                                Dimens
                                                                    .space18,
                                                              ),
                                                            ),
                                                            content: Text(
                                                              LocaleKeys
                                                                  .home_delete_attention_text
                                                                  .tr(),
                                                              style: TextStyle(
                                                                  fontSize: Dimens
                                                                      .space16),
                                                            ),
                                                            actions: [
                                                              CupertinoDialogAction(
                                                                child: Text(
                                                                  LocaleKeys
                                                                      .home_cancel
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      Dimens.space14),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(ctx)
                                                                      .pop();
                                                                },
                                                              ),
                                                              CupertinoDialogAction(
                                                                isDefaultAction:
                                                                true,
                                                                child: Text(
                                                                  LocaleKeys
                                                                      .home_delete
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                    Dimens
                                                                        .space14,
                                                                    color:
                                                                    Colors.red,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(ctx)
                                                                      .pop();
                                                                  context
                                                                      .read<
                                                                      HomeCubit>()
                                                                      .deleteTemplate(
                                                                      id: template
                                                                          .id!
                                                                          .toInt());
                                                                  context
                                                                      .read<
                                                                      HomeCubit>()
                                                                      .getTemplate(
                                                                      saved:
                                                                      "",
                                                                      sortBy:
                                                                      "",
                                                                      searchText:
                                                                      "");
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: AppColors.redAccent,
                                                      size: Dimens.space16,
                                                    ),
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
                                    height: 200,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white.withAlpha(10),
                                              Colors.white,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            builder: (context) => CreateTemplate(),
                          ),
                        );
                      },
                    ).paddingAll(value: Dimens.space10),
                  ),
                ],
              ).paddingSymmetric(horizontal: Dimens.space20),
            );
          }
          if (state is HomeGetTemplateError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: Dimens.space20,
                children: [
                  Text(
                    LocaleKeys.home_home_error.tr(),
                    style: TextStyle(
                      fontFamily: 'VelaSans',
                      fontSize: Dimens.space16,
                      fontWeight: FontWeight.w600,
                    ),
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
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.blueColor,
            ),
          );
        },
      ),
    );
  }
}