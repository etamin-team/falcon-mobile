import 'package:easy_localization/easy_localization.dart';
import 'package:wm_doctor/core/widgets/custom_progress_bar.dart';

import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../data/model/profile_data_model.dart';

class ProfileCard extends StatefulWidget {
  final ProfileDataModel model;

  const ProfileCard({super.key, required this.model});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  double allQuote = 0;
  double allAmount = 0;

  @override
  void initState() {
    calculate();
    super.initState();
  }

  void calculate() {
    for (var contract in widget.model.medicineWithQuantityDoctorDTOS) {

      double ball = 0;
      switch (widget.model.contractType) {
        case 'RECIPE':
          ball = contract.medicine.prescription ?? 0;
          break;
        case 'SU':
          ball = (contract.medicine.suBall ?? 0).toDouble();
          break;
        case 'SB':
          ball = (contract.medicine.sbBall ?? 0).toDouble();
          break;
        case 'GZ':
          ball = (contract.medicine.gzBall ?? 0).toDouble();
          break;
        case 'KZ':
          ball = (contract.medicine.kbBall ?? 0).toDouble();
          break;
        default:
          ball = 0;
      }

      allQuote += contract.quote * ball;
      allAmount += contract.contractMedicineDoctorAmount.amount * ball;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String fromDate = widget.model.startDate;
    String toDate = widget.model.endDate;

    double amountWidth = allQuote == 0 ? 0.0 : (MediaQuery.sizeOf(context).width * allAmount) / allQuote;

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
        if (widget.model.medicineWithQuantityDoctorDTOS.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space20),
                color: AppColors.white),
            child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.only(bottom: Dimens.space20),
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    LocaleKeys.profile_my_paket.tr(),
                    style: TextStyle(
                        fontFamily: 'VelaSans',
                        fontSize: Dimens.space18,
                        fontWeight: FontWeight.w700),
                  ),
                  children: List.generate(
                    widget.model.medicineWithQuantityDoctorDTOS.length,
                    (index) {
                      return CustomProgressBar(
                          title: widget
                                  .model
                                  .medicineWithQuantityDoctorDTOS[index]
                                  .medicine
                                  .name.toString(),
                          current: widget
                                  .model
                                  .medicineWithQuantityDoctorDTOS[index]
                                  .contractMedicineDoctorAmount
                                  .amount,
                          total: widget
                                  .model
                                  .medicineWithQuantityDoctorDTOS[index]
                                  .quote);
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
                    fontSize: Dimens.space18,
                    fontWeight: FontWeight.w700),
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
                        fontSize: Dimens.space18,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "${LocaleKeys.profile_step.tr()} $allQuote",
                    // "${LocaleKeys.profile_step.tr()} 256.000",
                    style: TextStyle(
                        fontFamily: 'VelaSans',
                        fontSize: Dimens.space14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Container(
                    width: MediaQuery.sizeOf(context).width,
                    alignment: AlignmentDirectional.centerStart,
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(Dimens.space10)),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Stack(
                        children: [
                          Container(
                            width: amountWidth == 0.0 ? 0 : amountWidth,
                            padding: EdgeInsets.symmetric(
                              // horizontal: Dimens.space20,
                                vertical: Dimens.space14),
                            decoration: BoxDecoration(
                                color: AppColors.lightGreen,
                                borderRadius:
                                BorderRadius.circular(Dimens.space10)),
                            child: Text(""),
                          ),
                          Positioned(
                            left: Dimens.space20,
                            right: Dimens.space20,
                            bottom: 0,
                            top: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.profile_passed.tr()),
                                Text("$allAmount"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              // ...List.generate(
              //   1,
              //   (index) {
              //     return Container(
              //       width: MediaQuery.sizeOf(context).width,
              //       decoration: BoxDecoration(
              //           color: AppColors.backgroundColor,
              //           borderRadius: BorderRadius.circular(Dimens.space10)),
              //       child: Container(
              //         width:
              //             20 /*(MediaQuery.sizeOf(context).width * allAmount) /
              //             allQuote*/
              //         ,
              //         padding: EdgeInsets.symmetric(
              //             horizontal: Dimens.space20, vertical: Dimens.space14),
              //         decoration: BoxDecoration(
              //             color: AppColors.lightGreen,
              //             borderRadius: BorderRadius.circular(Dimens.space10)),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(LocaleKeys.profile_passed.tr()),
              //             Text("$allAmount"),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
