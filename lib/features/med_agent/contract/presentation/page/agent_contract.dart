import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/core/utils/data_translate.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/utility/doctor_type.dart';
import 'package:wm_doctor/features/med_agent/contract/presentation/cubit/contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/cubit/contract_details_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/page/contract_details.dart';
import 'package:wm_doctor/features/regions/presentation/page/regions_dialog.dart';
import 'package:wm_doctor/features/workplace/presentation/page/workplace_dialog.dart';

import '../../../../../core/utils/dependencies_injection.dart';
import '../../../../../core/widgets/export.dart';
import '../../data/model/contract_model.dart';

class AgentContract extends StatefulWidget {
  const AgentContract({super.key});

  @override
  State<AgentContract> createState() => _AgentContractState();
}

class _AgentContractState extends State<AgentContract> {
  LanguageModel regionName = LanguageModel(uz: '', ru: '', en: '');
  LanguageModel doctorType = LanguageModel(uz: '', ru: '', en: '');

  String workplaceName = "";
  int districtId = 0;
  int workplaceId = 0;
  final searchController = TextEditingController();
  Timer? _debounce;

  void _onFilterChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(seconds: 3), () {
      print("bajarildi======");
    });
  }

  @override
  void initState() {
    context.read<ContractCubit>().getContracts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Договора",
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.space30),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
        child: Column(
          spacing: Dimens.space20,
          children: [
            SizedBox(),
            Container(
              padding: EdgeInsets.all(Dimens.space20),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(Dimens.space20)),
              child: Column(
                spacing: Dimens.space10,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Регион",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: Dimens.space18),
                  ),
                  GestureDetector(
                    onTap: () {
                      showRegions(
                        ctx: context,
                        onChange: (value) {
                          regionName = value;
                          setState(() {});
                          _onFilterChanged();
                        },
                        districtId: (value) => districtId = value,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20, vertical: Dimens.space16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space10),
                          color: AppColors.backgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(regionName.uz == ""
                              ? "Район"
                              : dataTranslate(ctx: context, model: regionName)),
                          Icon(CupertinoIcons.chevron_down)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showWorkplaceDialog(
                        ctx: context,
                        name: (value) {
                          workplaceName = value;
                          setState(() {});
                          _onFilterChanged();
                        },
                        id: (value) => workplaceId = value,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20, vertical: Dimens.space16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space10),
                          color: AppColors.backgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(workplaceName == ""
                              ? "Место работы"
                              : workplaceName),
                          Icon(CupertinoIcons.chevron_down)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDoctorTypeList(
                        ctx: context,
                        onchange: (value) {
                          doctorType = value;
                          setState(() {});
                          _onFilterChanged();
                        },
                        realType: (value) {},
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.space20, vertical: Dimens.space16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.space10),
                          color: AppColors.backgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(doctorType.uz == ""
                              ? "Специальность"
                              : dataTranslate(ctx: context, model: doctorType)),
                          Icon(CupertinoIcons.chevron_down)
                        ],
                      ),
                    ),
                  ),
                  AppTextField(
                      onChanged: (value) {
                        _onFilterChanged();
                      },
                      controller: searchController,
                      hintText: "Ф.И.О. врача"),
                ],
              ),
            ),
            BlocConsumer<ContractCubit, ContractState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is ContractSuccess) {
                  return Container(
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20)),
                    child: Column(
                      spacing: Dimens.space10,
                      children: [
                        Row(
                          spacing: Dimens.space10,
                          children: [
                            SvgPicture.asset(Assets.icons.list),
                            Text(
                              "Все",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimens.space18),
                            )
                          ],
                        ),
                        ...List.generate(
                          state.list.length,
                          (index) {
                            return contractListItem(model: state.list[index]);
                          },
                        )
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            SizedBox(
              height: Dimens.space20,
            ),
          ],
        ),
      ),
    );
  }

  Widget contractListItem({required ContractModel model}) {
    List<String> names = [
      "Алтикам",
      "Ампилин",
      "Артокол мазь",
      "Артокол уколы",
      "Алтикам",
    ];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => sl<ContractDetailsCubit>(),
                      child: ContractDetails(
                        id: model.doctorId??"",
                      ),
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.space16),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(Dimens.space16)),
        child: Column(
          spacing: Dimens.space10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Договор №${model.id}",
                  style: TextStyle(
                      fontSize: Dimens.space16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: Dimens.space20,
                ),
                Icon(CupertinoIcons.right_chevron)
              ],
            ),
            Wrap(
              spacing: Dimens.space6,
              runSpacing: Dimens.space6,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: List.generate(
                model.medicinesWithQuantities?.take(6).length??0,
                (index) => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.space10, vertical: Dimens.space8),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(Dimens.space5)),
                  child: Text(model.medicinesWithQuantities?[index].medicine?.name??""),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
