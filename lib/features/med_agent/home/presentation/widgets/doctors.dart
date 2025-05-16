import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/cubit/contract_details_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/doctors_model.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/doctor/doctor_cubit.dart';

import '../../../../../core/utils/dependencies_injection.dart';
import '../../../contract_details/presentation/page/contract_details.dart';

showDoctors({required BuildContext ctx}) {
  final searchTextController = TextEditingController();
  showModalBottomSheet(
    useSafeArea: true,
    showDragHandle: true,
    enableDrag: true,
    isScrollControlled: true,
    context: ctx,
    backgroundColor: AppColors.backgroundColor,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return BlocBuilder<DoctorCubit, DoctorState>(
            builder: (context, state) {
              if (state is DoctorSuccess) {
                List<DoctorsModel> list = [];
                list.addAll(state.list);
                if (searchTextController.text.isNotEmpty) {
                  list = list.where(
                    (element) {
                      if (element.firstName!.toLowerCase().startsWith(
                              searchTextController.text.trim().toLowerCase()) ||
                          element.middleName!.toLowerCase().startsWith(
                              searchTextController.text.trim().toLowerCase()) ||
                          element.lastName!.toLowerCase().startsWith(
                              searchTextController.text.trim().toLowerCase())) {
                        return true;
                      }
                      return false;
                    },
                  ).toList();
                }
                return Scaffold(
                  backgroundColor: AppColors.backgroundColor,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    forceMaterialTransparency: true,
                    title: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        spacing: Dimens.space5,
                        children: [
                          Icon(
                            CupertinoIcons.left_chevron,
                            color: Colors.blueAccent,
                          ),
                          Text(
                            "Назад",
                            style: TextStyle(
                                fontSize: Dimens.space18,
                                color: AppColors.blueColor),
                          )
                        ],
                      ),
                    ),
                    actions: [
                      // UniversalButton.filled(
                      //   height: 40,
                      //   cornerRadius: Dimens.space10,
                      //   width: 130,
                      //   fontSize: Dimens.space14,
                      //   text: "Готово",
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      SizedBox(
                        width: Dimens.space10,
                      )
                    ],
                  ),
                  body: Column(
                    spacing: Dimens.space10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Dimens.space20,
                      ),
                      Text(
                        "Врачи",
                        style: TextStyle(
                            fontSize: Dimens.space30,
                            fontWeight: FontWeight.bold),
                      ),
                      AppTextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        backgroundColor: AppColors.white,
                        prefixIcon: Icon(CupertinoIcons.search),
                        controller: searchTextController,
                        hintText: "Поиск",
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(Dimens.space20),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(Dimens.space20)),
                          child: Column(
                            spacing: Dimens.space10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                spacing: Dimens.space5,
                                children: [
                                  SvgPicture.asset(Assets.icons.list),
                                  Text(
                                    "Все",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Dimens.space18),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: list.isEmpty?Center(child: Text("NO DATA"),): SingleChildScrollView(
                                  child: Column(
                                    spacing: Dimens.space10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: List.generate(
                                      list.length,
                                      (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            BlocProvider(
                                                              create: (context) =>
                                                                  sl<ContractDetailsCubit>(),
                                                              child:
                                                                  ContractDetails(
                                                                id: list[index]
                                                                        .userId ??
                                                                    "",
                                                              ),
                                                            )));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimens.space20,
                                                vertical: Dimens.space16),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.space10),
                                                color:
                                                    AppColors.backgroundColor),
                                            child: Text(
                                                "${list[index].firstName} ${list[index].middleName ?? ""} ${list[index].lastName ?? ""}"),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: Dimens.space30),
                );
              }
              if (state is DoctorLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox();
            },
          );
        },
      );
    },
  );
}
