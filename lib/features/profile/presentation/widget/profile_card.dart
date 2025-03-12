import 'package:easy_localization/easy_localization.dart';
import 'package:wm_doctor/core/widgets/custom_progress_bar.dart';

import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../data/model/profile_data_model.dart';

class ProfileCard extends StatelessWidget {
  final ProfileDataModel model;

  const ProfileCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    String fromDate =model.startDate ??
        DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    String toDate =model.endDate ??
        DateFormat('dd/MM/yyyy').format( DateTime.now());

    return Column(
      spacing: Dimens.space10,
      children: [
        // Container(
        //   padding: EdgeInsets.all(Dimens.space20),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(Dimens.space20),
        //       color: AppColors.white),
        //   child: Column(
        //     children: [
        //       Row(
        //         spacing: Dimens.space10,
        //         children: [
        //           SvgPicture.asset(Assets.icons.filter),
        //           Text(
        //             "Фильтры",
        //             style: TextStyle(
        // fontFamily: 'VelaSans',

        //                 fontSize: Dimens.space18,
        //                 fontWeight: FontWeight.w700),
        //           )
        //         ],
        //       ),
        //       SizedBox(
        //         height: Dimens.space20,
        //       ),
        //       Container(
        //         padding: EdgeInsets.symmetric(
        //             horizontal: Dimens.space14,
        //             vertical: Dimens.space16),
        //         decoration: BoxDecoration(
        //             color: AppColors.backgroundColor,
        //             borderRadius:
        //             BorderRadius.circular(Dimens.space10)),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           spacing: Dimens.space10,
        //           children: [
        //             Text(
        //               "C 29/11/2024 по 02/12/2024",
        //               style: TextStyle(
        // fontFamily: 'VelaSans',

        //                   fontSize: Dimens.space14,
        //                   fontWeight: FontWeight.w400),
        //             ),
        //             SvgPicture.asset(Assets.icons.calendar),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.space20),
              color: AppColors.white),
          child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.only(bottom: Dimens.space20),
                tilePadding: EdgeInsets.zero,
                title: Text(
                  LocaleKeys.profile_my_paket.tr(),
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                  
                      fontSize: Dimens.space18, fontWeight: FontWeight.w700),
                ),
                children: List.generate(
                  model.contractedMedicineWithQuantity.length ?? 0,
                  (index) {
                    return CustomProgressBar(
                        title: model.contractedMedicineWithQuantity[index].medicine.name??
                            "-",
                        current: model.contractedMedicineWithQuantity[index]
                                .contractMedicineAmount.amount ??
                            0,
                        total: model
                                .contractedMedicineWithQuantity[index].quote ??
                            0);
                  },
                ),
              )),
        ),
        Container(
          padding: EdgeInsets.all(Dimens.space20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.space20),
              color: AppColors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.profile_execution_period.tr(),
                style: TextStyle(
                  fontFamily: 'VelaSans',

                    fontSize: Dimens.space18, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: Dimens.space20,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimens.space14, vertical: Dimens.space16),
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(Dimens.space10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: Dimens.space10,
                  children: [
                    Text(
                      "C  $fromDate  по  $toDate",
                      style: TextStyle(
                        fontFamily: 'VelaSans',

                          fontSize: Dimens.space14,
                          fontWeight: FontWeight.w400),
                    ),
                    SvgPicture.asset(Assets.icons.calendar),
                  ],
                ),
              ),
            ],
          ),
        ),


        Container(
          padding: EdgeInsets.all(Dimens.space20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.space20),
              color: AppColors.white),
          child: Column(
            spacing: Dimens.space10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.profile_target.tr(),
                    style: TextStyle(
                      fontFamily: 'VelaSans',

                        fontSize: Dimens.space18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "${LocaleKeys.profile_step.tr()} 256.000",
                    style: TextStyle(
                      fontFamily: 'VelaSans',

                        fontSize: Dimens.space14, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              ...List.generate(
                1,
                (index) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(Dimens.space10)),
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20, vertical: Dimens.space14),
                      decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(Dimens.space10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LocaleKeys.profile_passed.tr()),
                          Text("22"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
