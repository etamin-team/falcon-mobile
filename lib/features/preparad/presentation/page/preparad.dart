import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/medicine/presentation/cubit/medicine_cubit.dart';

import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../create_template/data/model/medicine_model.dart';

class PreparadPage extends StatefulWidget {
  const PreparadPage({super.key});

  @override
  State<PreparadPage> createState() => _PreparadPageState();
}

class _PreparadPageState extends State<PreparadPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MedicineCubit>().getMedicine(); // Ma'lumotlarni olish
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Text(
          LocaleKeys.texts_preparation.tr(),
          style: TextStyle(
              fontFamily: 'VelaSans',
              fontSize: Dimens.space30,
              fontWeight: FontWeight.w800),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                LocaleKeys.texts_back.tr(),
                style: TextStyle(
                    fontFamily: 'VelaSans',
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimens.space16),
              )).paddingOnly(right: Dimens.space10)
        ],
      ),
      body: BlocConsumer<MedicineCubit, MedicineState>(
        listener: (context, state) {
          if (state is MedicineError) {
            print("Error: ${state.failure}");
          }
        },
        builder: (context, state) {
          if (state is MedicineError) {
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
                      context.read<MedicineCubit>().getMedicine();
                    },
                  )
                ],
              ),
            );
          }
          if (state is MedicineSuccess) {
            List<MedicineModel> list = state.list;

            if (searchController.text.isNotEmpty) {
              list = list
                  .where((element) => (element.name ?? "")
                  .toLowerCase()
                  .startsWith(searchController.text.trim().toLowerCase()))
                  .toList();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Dimens.space20),
                  Container(
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.space20),
                        color: AppColors.white),
                    child: Column(
                      children: [
                        Row(
                          spacing: Dimens.space10,
                          children: [
                            SvgPicture.asset(Assets.icons.filter),
                            Text(
                              textAlign: TextAlign.center,
                              LocaleKeys.texts_filters.tr(),
                              style: TextStyle(
                                  fontFamily: 'VelaSans',
                                  fontSize: Dimens.space18,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        SizedBox(height: Dimens.space10),
                        AppTextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          controller: searchController,
                          hintText: LocaleKeys.texts_search.tr(),
                          prefixIcon: Icon(CupertinoIcons.search),
                        ),
                        SizedBox(height: Dimens.space10),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.space20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimens.space10, horizontal: Dimens.space16),
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.all(Dimens.space6),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(Dimens.space16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Expanded(
                            //     child: CachedNetworkImage(
                            //       imageUrl: list[index].imageUrl ?? "",
                            //       placeholder: (context, url) =>
                            //           Center(child: CircularProgressIndicator()),
                            //       errorWidget: (context, url, error) => Image.network(
                            //           "https://www.pharmacieonline.lu/wp-content/uploads/2020/11/29ae1645a986b0800cec8ad6365882eb-1.jpg"),
                            //     )),
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: list[index].imageUrl ?? "",
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Image.asset("images/pill-min.png"),
                              ),
                            ),

                            Text(
                              list[index].name ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'VelaSans',
                                  fontSize: Dimens.space14,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      );
                    },
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
    );
  }
}