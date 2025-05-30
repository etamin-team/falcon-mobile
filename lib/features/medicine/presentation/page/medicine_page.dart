import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/utils/data_translate.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/entity/regison_entity.dart';

import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../create_template/data/model/medicine_model.dart';
import '../cubit/medicine_cubit.dart';

class MedicinePage extends StatefulWidget {
  final List<MedicineModel> medicine;

  final ValueChanged<MedicineModel> model;

  const MedicinePage({super.key, required this.medicine, required this.model});

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text(LocaleKeys.texts_preparation.tr()),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                LocaleKeys.texts_back.tr(),
                style: TextStyle(
                    color: AppColors.blueColor,
                    fontSize: Dimens.space16,
                    fontWeight: FontWeight.w500),
              )),
          SizedBox(
            width: Dimens.space10,
          )
        ],
      ),
      body: BlocConsumer<MedicineCubit, MedicineState>(
        listener: (context, state) {
          if (state is MedicineSuccess) {
            print("this is listen data  ============> ${state.list.length}");
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is MedicineSuccess) {
            final List<MedicineModel> dataList = [];
            dataList.addAll(state.list);
            List<MedicineModel> list = widget.medicine;
            // List<MedicineModel> list = dataList;
            if (searchController.text.isNotEmpty) {
              list = widget.medicine
                  .where((element) => (element.name ?? "")
                  .toLowerCase()
                  .startsWith(searchController.text.trim().toLowerCase()))
                  .toList();
              /*list = state.list
                  .where((element) => (element.name ?? "")
                      .toLowerCase()
                      .startsWith(searchController.text.trim().toLowerCase()))
                  .toList();*/
            }
            /*if (widget.medicine.isNotEmpty) {
              list.removeWhere(
                (element) => widget.medicine.any(
                  (data) => element.id == data.id,
                ),
              );
            }*/

            if (widget.medicine.isEmpty) {
              return Center(
                child: Text("Ro'yhat bo'sh!"),
              );
            }

            return Column(
              spacing: Dimens.space30,
              children: [
                AppTextField(
                  controller: searchController,
                  hintText: LocaleKeys.texts_search.tr(),
                  onChanged: (value) {
                    setState(() {});
                  },
                  backgroundColor: AppColors.white,
                ).paddingSymmetric(horizontal: Dimens.space20),
                Expanded(
                  child: (searchController.text.trim().isNotEmpty &&
                      list.isEmpty)
                      ? Center(
                    child:
                    Text("Qidiruv natijasida hechnarsa topilmadi!"),
                  )
                      : SingleChildScrollView(
                    padding:
                    EdgeInsets.symmetric(horizontal: Dimens.space20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: Dimens.space10,
                      children: List.generate(
                        list.length,
                            (index) {
                          return GestureDetector(
                            onTap: () {
                              widget.model(list[index]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(
                                      Dimens.space10)),
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: Dimens.space20,
                              //     vertical: Dimens.space16),
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimens.space20),
                                title: Tooltip(
                                  message:
                                  "${list[index].name ?? ""} (${list[index].prescription ?? 0} ${list[index].volume ?? ""})",
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          list[index].name ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Dimens.space14),
                                        ),
                                      ),
                                      Text(
                                        " (${list[index].prescription ?? 0} ${list[index].volume ?? ""})",
                                        style: TextStyle(
                                            fontFamily: 'VelaSans',
                                            fontWeight: FontWeight.w600,
                                            fontSize: Dimens.space12),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Text(
                                  dataTranslate(
                                      ctx: context,
                                      model: checkMedicineType(
                                          name: list[index].type ?? "")),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimens.space10,
                )
              ],
            );
          }
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
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}