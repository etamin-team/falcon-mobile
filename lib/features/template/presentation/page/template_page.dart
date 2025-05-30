import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/create_template/presentation/page/create_template.dart';

import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../home/data/model/template_model.dart';

class TemplatePage2 extends StatefulWidget {
  final TemplateModel model;

  const TemplatePage2({super.key, required this.model});

  @override
  State<TemplatePage2> createState() => _TemplatePage2State();
}

class _TemplatePage2State extends State<TemplatePage2> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Text(
          widget.model.name??"",
          style: TextStyle(
              fontSize: Dimens.space30,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        actions: [
          TextButton(
            child: Text(
              LocaleKeys.texts_back.tr(),
              style: TextStyle(
                  fontFamily: 'VelaSans',
                  fontWeight: FontWeight.w600,
                  fontSize: Dimens.space16,
                  color: AppColors.blueColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ).paddingOnly(right: Dimens.space20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: Dimens.space10,
          children: [
            SizedBox(),
            TemplateItem(
                title: LocaleKeys.template_diagnosis.tr(),
                hint: "ОРЗ / ОРВИ",
                text: widget.model.diagnosis??""),
            // TemplateItem(
            //     title: "МНН", hint: "VIASART", text: ""),
            // TemplateItem(
            //     title: "ТН W.M.", hint: "Виасарт", text: ""),
            ...List.generate(
              widget.model.preparations?.length??0,
                  (index) {
                return Column(
                  spacing: Dimens.space10,
                  children: [
                    TemplateItem(
                        title: LocaleKeys.template_description.tr(),
                        hint: LocaleKeys.template_viasart.tr(),
                        text: widget.model.preparations?[index].name??""),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimens.space20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Dimens.space10,
                        children: [
                          Text(
                            LocaleKeys.template_form_and_dose.tr(),
                            style: TextStyle(
                                fontFamily: 'VelaSans',
                                fontWeight: FontWeight.w700,
                                fontSize: Dimens.space18,
                                color: Colors.black87),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.space20,
                                vertical: Dimens.space16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              spacing: Dimens.space10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.model.preparations?[index].type??"",
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimens.space12),
                                ),
                                Icon(
                                  CupertinoIcons.chevron_down,
                                  color: Colors.black38,
                                  size: Dimens.space20,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.space20,
                                vertical: Dimens.space16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              spacing: Dimens.space10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.model.preparations?[index].amount??"",
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimens.space12),
                                ),
                                Icon(
                                  CupertinoIcons.chevron_down,
                                  color: Colors.black38,
                                  size: Dimens.space20,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimens.space20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Dimens.space10,
                        children: [
                          Text(
                            LocaleKeys.template_dosage.tr(),
                            style: TextStyle(
                              fontFamily: 'VelaSans',
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: Dimens.space18,
                            ),
                          ),
                          Row(
                            spacing: Dimens.space10,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space20,
                                      vertical: Dimens.space16),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    (widget.model.preparations?[index].quantity??0)
                                        .toString(),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Dimens.space16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space20,
                                      vertical: Dimens.space16),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    (  widget.model.preparations?[index].timesInDay??0)
                                        .toString(),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Dimens.space16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.space20,
                                      vertical: Dimens.space16),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    (widget.model.preparations?[index].days??0)
                                        .toString(),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Dimens.space16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            spacing: Dimens.space10,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    LocaleKeys.template_quantity.tr(),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Dimens.space12),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    LocaleKeys.template_timeInDay.tr(),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Dimens.space12),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    LocaleKeys.template_days.tr(),
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Dimens.space12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Dimens.space20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimens.space10,
                children: [
                  Text(
                    LocaleKeys.template_notes.tr(),
                    style: TextStyle(
                        fontFamily: 'VelaSans',
                        fontWeight: FontWeight.w700,
                        fontSize: Dimens.space18,
                        color: Colors.black87),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.space20, vertical: Dimens.space16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.model.note??"",
                      style: GoogleFonts.ubuntu(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimens.space12),
                    ),
                  ),
                ],
              ),
            ),
            UniversalButton.filled(
              cornerRadius: Dimens.space16,
              fontSize: Dimens.space14,
              text: LocaleKeys.template_edit.tr(),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateTemplate(
                          model: widget.model,
                        )));
              },
            ),
            SizedBox(
              height: Dimens.space20,
            ),
          ],
        ).paddingSymmetric(horizontal: Dimens.space20),
      ),
    );
  }

  Widget TemplateItem(
      {required String title, required String hint, required String text}) {
    TextEditingController controller = TextEditingController();
    controller.text = text;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.space10,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'VelaSans',
                fontWeight: FontWeight.w700,
                fontSize: Dimens.space18,
                color: Colors.black87),
          ),
          AppTextField(
            textColor: Colors.black87,
            controller: controller,
            hintText: hint,
            isEnabled: false,
            maxLines: 20,
          ),
        ],
      ),
    );
  }
}