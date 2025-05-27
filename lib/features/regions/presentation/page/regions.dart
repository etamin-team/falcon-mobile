import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/utils/data_translate.dart';
import 'package:wm_doctor/features/regions/presentation/cubit/regions_cubit.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../../core/model/language_model.dart';
import '../../../../core/widgets/export.dart';

class RegionsPage extends StatefulWidget {
  final ValueChanged<LanguageModel> onChange;

  final ValueChanged<int> districtId;

  const RegionsPage({
    super.key,
    required this.onChange,
    required this.districtId,
  });

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}


class _RegionsPageState extends State<RegionsPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionsCubit, RegionsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is RegionsSuccess ) {
          final filteredRegions = state.regions.where((region) {

            final regionName = region.name.toLowerCase();
            final districts = region.districts
                .where((district) => district.name
                    .toLowerCase()
                    .contains(searchController.text.trim()))
                .toList();

            return regionName.contains(searchController.text.trim()) ||
                districts.isNotEmpty;

          }).toList();
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
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
                      LocaleKeys.texts_back.tr(),
                      style: TextStyle(
                        fontFamily: 'VelaSans',
                          fontSize: Dimens.space16, color: AppColors.blueColor),
                    )
                  ],
                ),
              ),
              actions: [
                UniversalButton.filled(
                    text: LocaleKeys.texts_ready.tr(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    width: 130,
                    margin: EdgeInsets.all(Dimens.space10),
                    cornerRadius: Dimens.space10)
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.space10,
              children: [
                Text(
                  LocaleKeys.texts_region.tr(),
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                      fontSize: 26, fontWeight: FontWeight.w800),
                ),
                AppTextField(
                  backgroundColor: AppColors.white,
                  controller: searchController,
                  hintText: LocaleKeys.texts_search.tr(),
                  prefixIcon: Icon(CupertinoIcons.search),
                  onChanged: (value) {
                    setState(() {});
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
                            "HELLO",
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
                                        title: Text(dataTranslate(
                                            ctx: context,
                                            model: LanguageModel(
                                                uz: filteredRegions[index]
                                                    .nameUzLatin
                                                    .toString(),
                                                ru: filteredRegions[index]
                                                    .nameRussian
                                                    .toString(),
                                                en: filteredRegions[index]
                                                    .name
                                                    .toString()))),
                                        children: filteredRegions[index]
                                            .districts
                                            .map<Widget>((district) {
                                          return ListTile(
                                            onTap: () {
                                              widget.onChange(LanguageModel(
                                                  uz: district.nameUzLatin,
                                                  ru: district.nameRussian,
                                                  en: district.name));
                                              widget.districtId(
                                                  district.districtId);
                                              Navigator.pop(context);
                                            },
                                            title: Text(dataTranslate(
                                                ctx: context,
                                                model: LanguageModel(
                                                    uz: district.nameUzLatin,
                                                    ru: district.nameRussian,
                                                    en: district.name))),
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
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
