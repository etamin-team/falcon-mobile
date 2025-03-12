import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/constant/diments.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/styles/app_colors.dart';
import 'package:wm_doctor/core/widgets/custom_text_form_field.dart';
import 'package:wm_doctor/features/workplace/presentation/cubit/workplace_cubit.dart';

import '../../../../gen/locale_keys.g.dart';
import '../../../auth/sign_up/data/model/workplace_model.dart';

class WorkplacePage extends StatefulWidget {
  final ValueChanged<String> name;
  final ValueChanged<int> id;

  const WorkplacePage({super.key, required this.name, required this.id});

  @override
  State<WorkplacePage> createState() => _WorkplacePageState();
}

class _WorkplacePageState extends State<WorkplacePage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text(LocaleKeys.texts_workplace.tr()),
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
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<WorkplaceCubit, WorkplaceState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is WorkplaceSuccess) {
            List<WorkplaceModel> list = state.workplace;
            if (searchController.text.isNotEmpty) {
              list = state.workplace
                  .where((element) => (element.name ?? "")
                      .toLowerCase()
                      .startsWith(searchController.text.trim().toLowerCase()))
                  .toList();
            }
            return Column(
              spacing: Dimens.space20,
              children: [
                AppTextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: searchController,
                  hintText: LocaleKeys.texts_search.tr(),
                  prefixIcon: Icon(CupertinoIcons.search),
                  backgroundColor: AppColors.white,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: Dimens.space10,
                      children: List.generate(
                        list.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              widget.name(list[index].name);
                              widget.id(list[index].id);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius:
                                      BorderRadius.circular(Dimens.space10)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.space20,
                                  vertical: Dimens.space12),
                              child: Text(
                                list[index].name,
                                style: TextStyle(
                                    fontSize: Dimens.space16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingAll(value: Dimens.space20);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
