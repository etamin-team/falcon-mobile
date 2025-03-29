import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';

import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../create_recept/presentation/page/create_recep.dart';
import '../cubit/mnn_cubit.dart';

class MNNPage extends StatefulWidget {
  final List<MnnModel> mnn;
  final ValueChanged<MnnModel> model;
  final List<MnnModel> initialSelectedItems; // Yangi parameter - boshlang'ich tanlangan elementlar
  final Function(List<MnnModel>) onSelectionComplete; // Yangi parameter - tanlash tugallanganda chaqiriladigan funksiya

  const MNNPage({
    super.key,
    required this.mnn,
    required this.model,
    required this.initialSelectedItems,
    required this.onSelectionComplete,
  });
  @override
  State<MNNPage> createState() => _MNNPageState();

  // Static metodni o'zgartiramiz
  static List<MnnModel> getSelectedItems() {
    return []; // Bo'sh ro'yxat qaytaradi, biz endi buni ishlatmaymiz
  }
}

class _MNNPageState extends State<MNNPage> {
  final searchController = TextEditingController();
  late List<MnnModel> selectedItems; // Statik emas, endi lokal o'zgaruvchi

  @override
  void initState() {
    super.initState();
    // Boshlang'ich tanlangan elementlarni nusxalash
    selectedItems = List<MnnModel>.from(widget.initialSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(LocaleKeys.create_recep_inns.tr()),
        actions: [
          TextButton(
            onPressed: () {
              // Tanlash tugallanganda callbackni chaqirish
              widget.onSelectionComplete(selectedItems);
              Navigator.pop(context);
            },
            child: Text(
              LocaleKeys.texts_ready.tr(),
              style: TextStyle(
                  color: AppColors.blueColor,
                  fontSize: Dimens.space16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: Dimens.space10),
        ],
      ),
      body: BlocConsumer<MnnCubit, MnnState>(
        listener: (context, state) {
          if (state is MnnSuccess) {
            print("Loaded ${state.list.length} items");
          } else {
            print("MNN ERROR");
          }
        },
        builder: (context, state) {
          if (state is MnnSuccess) {
            List<MnnModel> list = state.list.where((element) {
              return (element.name ?? "")
                  .toLowerCase()
                  .startsWith(searchController.text.trim().toLowerCase());
            }).toList();

            return Column(
              children: [
                AppTextField(
                  padding: EdgeInsets.only(bottom: 15,top: 10),
                  controller: searchController,
                  hintText: LocaleKeys.texts_search.tr(),
                  onChanged: (value) {
                    setState(() {});
                  },
                  backgroundColor: AppColors.white,
                ).paddingSymmetric(horizontal: Dimens.space20),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(list.length, (index) {
                        final item = list[index];
                        final isChecked = selectedItems.contains(item);
                        print("$index-item :::: ${item.name}\n${selectedItems}\n\n$index-item ==>> isChecked ::: $isChecked");
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isChecked) {
                                selectedItems.remove(item);
                              } else {
                                selectedItems.add(item);
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(Dimens.space10),
                            ),
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dimens.space20),
                              title: Text(
                                item.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Dimens.space14),
                              ),
                              trailing: CheckboxTheme(
                                data: CheckboxThemeData(
                                  fillColor: MaterialStateProperty.all(
                                      AppColors.blueColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimens.space5),
                                  ),
                                  checkColor: MaterialStateProperty.all(
                                      AppColors.white),
                                  side: BorderSide(
                                      color: AppColors.blueColor,
                                      width: 3),
                                ),
                                child: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedItems.add(item);
                                      } else {
                                        selectedItems.remove(item);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is MnnError) {
            return Center(
              child: Column(
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
                      context.read<MnnCubit>().getMnn();
                    },
                  )
                ],
              ),
            );
          }
          print(context.read<MnnCubit>().getMnn());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("Unexpected error \n please restart the application"),
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
