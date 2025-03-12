import 'package:flutter/cupertino.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/region_model.dart';

import '../../../../../core/widgets/export.dart';
import '../../domain/entity/regison_entity.dart';

showRegionsList(
    {required BuildContext ctx, required ValueChanged<String> onChange, required ValueChanged<int> districtId,required List<RegionModel>regions}) {

  final searchController = TextEditingController();
  String searchQuery = '';
  showModalBottomSheet(
    useSafeArea: true,
    showDragHandle: true,
    enableDrag: true,
    backgroundColor: Color(0xFFF5F6FA),
    isScrollControlled: true,
    context: ctx,
    builder: (context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          final filteredRegions = regions.where((region) {
            final regionName = region.name.toLowerCase();
            final districts = region.districts.where((district) =>
                    district.name.toLowerCase().contains(searchQuery))
                .toList();

            return regionName.contains(searchQuery) || districts.isNotEmpty;
          }).toList();
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              title: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: Dimens.space5,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_outlined,
                      color: AppColors.blueColor,
                    ),
                    Text(
                      "Назад",
                      style: TextStyle(
                        fontFamily: 'VelaSans',
                          fontSize: Dimens.space16, color: AppColors.blueColor),
                    )
                  ],
                ),
              ),
              actions: [
                UniversalButton.filled(
                    text: "Готово",
                    onPressed: () {},
                    width: Dimens.space100,
                    margin: EdgeInsets.all(Dimens.space10),
                    cornerRadius: Dimens.space10)
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.space10,
              children: [
                Text(
                  "Город",
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                      fontSize: 32, fontWeight: FontWeight.w800),
                ),
                AppTextField(
                  backgroundColor: AppColors.white,
                  controller: searchController,
                  hintText: "Поиск",
                  prefixIcon: Icon(CupertinoIcons.search),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20)),
                    padding: EdgeInsets.all(Dimens.space20),
                    child: Column(
                      children: [
                        Row(
                          spacing: Dimens.space10,
                          children: [
                            SvgPicture.asset(Assets.icons.list),
                            Text(
                              "Все",
                              style: TextStyle(
                                fontFamily: 'VelaSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: Dimens.space18),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dimens.space10,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                filteredRegions.length,
                                (index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: Dimens.space4),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF5F6FA),
                                        borderRadius: BorderRadius.circular(
                                            Dimens.space10)),
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: Dimens.space20,
                                    //     vertical: Dimens.space16),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: Dimens.space20),
                                        childrenPadding: EdgeInsets.zero,
                                        title: Text(filteredRegions[index]
                                                .name
                                            .toString()),
                                        children: filteredRegions[index].districts
                                            .map<Widget>((district) {
                                          return ListTile(
                                            onTap: () {
                                              onChange(filteredRegions[index].name
                                                  .toString());
                                              districtId(filteredRegions[index].id);
                                              Navigator.pop(context);
                                            },
                                            title: Text(district.name??""),
                                            dense: true,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ).paddingOnly(left: Dimens.space30);
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ).paddingSymmetric(horizontal: Dimens.space20),
          );
        },
      );
    },
  );
}
