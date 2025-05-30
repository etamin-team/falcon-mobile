import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/home/data/model/template_model.dart';
import 'package:wm_doctor/features/home/presentation/cubit/home_cubit.dart';
import 'package:wm_doctor/features/template/presentation/page/template_page.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../../core/utils/dependencies_injection.dart';
import '../../../create_template/presentation/page/create_template.dart';

class TemplatePage extends StatefulWidget {
  final bool isBottom;
  ValueChanged<TemplateModel> onChange;

  TemplatePage({super.key, this.isBottom = false, required this.onChange});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  final searchController = TextEditingController();
  List<TemplateModel> list = [];
  String filterBy = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Text(
          LocaleKeys.template_template.tr(),
          style: TextStyle(
              fontFamily: 'VelaSans',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.black),
        ),
        actions: [
          TextButton(
            child: Text(
              LocaleKeys.texts_back.tr(),
              style: TextStyle(
                  fontFamily: 'VelaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: Dimens.space16,
                  color: AppColors.blueColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ).paddingOnly(right: Dimens.space20),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeGetTemplateSuccess) {
            setState(() {
              list = state.list;
            });
          }
        },
        builder: (context, state) {
          if (state is HomeGetTemplateSuccess) {
            if (list.isEmpty) {
              list = state.list;
            }

            List<TemplateModel> savedList = list
                .where(
                  (element) => (element.saved),
            )
                .toList();
            List<TemplateModel> templateList = list
                .where(
                  (element) => (!element.saved),
            )
                .toList();

            if (searchController.text.isNotEmpty) {
              savedList = savedList
                  .where(
                    (element) => element.name!
                    .toLowerCase()
                    .startsWith(searchController.text.toLowerCase()),
              )
                  .toList();
              templateList = templateList
                  .where(
                    (element) => element.name!
                    .toLowerCase()
                    .startsWith(searchController.text.toLowerCase()),
              )
                  .toList();
            }
            if (filterBy == "byAlphabet") {
              list.sort((a, b) => (a.name??"").compareTo((b.name??"")));
            } else if (filterBy == "byImportant") {
              templateList.clear();
            } else if (filterBy == "byTime") {
              list.sort((a, b) => (a.id??0).compareTo((b.id??0)));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Dimens.space20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20)),
                    padding: EdgeInsets.all(Dimens.space16),
                    child: Column(
                      children: [
                        Row(
                          spacing: Dimens.space10,
                          children: [
                            SvgPicture.asset(Assets.icons.filter),
                            Text(
                              LocaleKeys.texts_filters.tr(),
                              style: TextStyle(
                                  fontFamily: 'VelaSans',
                                  fontSize: Dimens.space18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                        AppTextField(
                          controller: searchController,
                          hintText: LocaleKeys.texts_search.tr(),
                          prefixIcon: Icon(CupertinoIcons.search),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                        Row(
                          spacing: Dimens.space5,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  list.sort((a, b) => a.name!.compareTo(b.name!));
                                  setState(() {
                                    filterBy = "byAlphabet";
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: filterBy == "byAlphabet"
                                          ? AppColors.blueColor
                                          : AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimens.space10)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space5,
                                      vertical: Dimens.space16),
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      LocaleKeys.texts_by_alphabet.tr(),
                                      style: TextStyle(
                                          color: filterBy == "byAlphabet"
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'VelaSans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: Dimens.space12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    filterBy = "byImportant";
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: filterBy == "byImportant"
                                          ? AppColors.blueColor
                                          : AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimens.space10)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space5,
                                      vertical: Dimens.space16),
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      LocaleKeys.texts_by_priority.tr(),
                                      style: TextStyle(
                                          fontFamily: 'VelaSans',
                                          color: filterBy == "byImportant"
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: Dimens.space12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    filterBy = "byTime";
                                  });
                                  setState(() {

                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: filterBy == "byTime"
                                          ? AppColors.blueColor
                                          : AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimens.space10)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space5,
                                      vertical: Dimens.space16),
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      LocaleKeys.texts_by_chronology.tr(),
                                      style: TextStyle(
                                          color: filterBy == "byTime"
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'VelaSans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: Dimens.space12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (savedList.isNotEmpty)
                    SizedBox(
                      height: Dimens.space20,
                    ),
                  if (savedList.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space20)),
                      padding: EdgeInsets.all(Dimens.space16),
                      child: Column(
                        spacing: Dimens.space10,
                        children: [
                          Row(
                            spacing: Dimens.space10,
                            children: [
                              SvgPicture.asset(Assets.icons.stars),
                              Text(
                                LocaleKeys.template_important.tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          ...List.generate(
                            savedList.length,
                                (index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  if (widget.isBottom) {
                                    widget.onChange(savedList[index]);
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TemplatePage2(
                                              model: savedList[index],
                                            )));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.backgroundColor),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space20,
                                      vertical: Dimens.space16),
                                  child: Row(
                                    spacing: Dimens.space10,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          savedList[index].name??"",
                                          style: TextStyle(
                                              fontFamily: 'VelaSans',
                                              fontSize: Dimens.space12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimens.space5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.isBottom) {
                                            widget.onChange(savedList[index]);
                                            Navigator.pop(context);
                                          } else {
                                            int i = list.indexWhere((p) =>
                                            p.id == savedList[index].id);
                                            if (i != -1) {
                                              list[i].saved = false;
                                            }
                                            savedChange(
                                                id: savedList[index]
                                                    .id
                                                    .toString(),
                                                saved: false);
                                            setState(() {});
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            Assets.icons.bookMarkFilled),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: Dimens.space20,
                  ),
                  if (templateList.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space20)),
                      padding: EdgeInsets.all(Dimens.space16),
                      child: Column(
                        spacing: Dimens.space10,
                        children: [
                          Row(
                            spacing: Dimens.space10,
                            children: [
                              SvgPicture.asset(Assets.icons.list),
                              Text(
                                LocaleKeys.template_all.tr(),
                                style: TextStyle(
                                    fontFamily: 'VelaSans',
                                    fontSize: Dimens.space18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          ...List.generate(
                            templateList.length,
                                (index) {
                              return InkWell(
                                onTap: () {
                                  if (widget.isBottom) {
                                    widget.onChange(templateList[index]);
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TemplatePage2(
                                              model: templateList[index],
                                            )));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.backgroundColor),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space20,
                                      vertical: Dimens.space16),
                                  child: Row(
                                    spacing: Dimens.space10,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          templateList[index].name??"",
                                          style: TextStyle(
                                              fontFamily: 'VelaSans',
                                              fontSize: Dimens.space12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimens.space5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.isBottom) {
                                            widget
                                                .onChange(templateList[index]);
                                            Navigator.pop(context);
                                          } else {
                                            int i = list.indexWhere((p) =>
                                            p.id == templateList[index].id);
                                            if (i != -1) {
                                              list[i].saved = true;
                                            }
                                            savedChange(
                                                id: templateList[index]
                                                    .id
                                                    .toString(),
                                                saved: true);
                                            setState(() {});
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            Assets.icons.bookMarkOuline),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: Dimens.space20,
                  )
                ],
              ).paddingSymmetric(horizontal: Dimens.space20),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: widget.isBottom
          ? null
          : UniversalButton.filled(
        height: Dimens.space60,
        cornerRadius: Dimens.space16,
        text: LocaleKeys.template_add_template.tr(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateTemplate()));
        },
      ).paddingOnly(
          right: Dimens.space20,
          left: Dimens.space20,
          bottom: Dimens.space20),
    );
  }

  void savedChange({required String id, required bool saved}) async {
    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/doctor/save-template/$id?save=$saved",
        body: {},
        isHeader: true);
    if (request.isSuccess) {
      debugPrint(
          "==================== template saved changed ====================");
    }
  }
}