import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/utils/data_translate.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/entity/regison_entity.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/create_template/data/model/upload_template_model.dart';
import 'package:wm_doctor/features/create_template/presentation/cubit/create_template_cubit.dart';
import 'package:wm_doctor/features/home/presentation/cubit/home_cubit.dart';
import 'package:wm_doctor/features/medicine/presentation/page/medicine_dialog.dart';

import '../../../../core/services/secure_storage.dart';
import '../../../../core/widgets/export.dart';
import '../../../../core/widgets/number_picker.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../home/data/model/template_model.dart';

class CreateTemplate extends StatefulWidget {
  final TemplateModel? model;

  const CreateTemplate({super.key, this.model});

  @override
  State<CreateTemplate> createState() => _CreateTemplateState();
}

class _CreateTemplateState extends State<CreateTemplate> {
  final textController = TextEditingController();
  final diagnosisController = TextEditingController();
  final noteController = TextEditingController();

  List<Preparation> preparation = [];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<CreateTemplateCubit>().getMedicine(inn: []);

    if (widget.model != null) {
      textController.text = widget.model?.name ?? "";
      diagnosisController.text = widget.model?.diagnosis ?? "";
      noteController.text = widget.model?.note ?? "";
      preparation =
          List.generate(widget.model?.preparations?.length ?? 0, (index) {
            return Preparation(name: widget.model?.preparations?[index].name??"",
                amount:  widget.model?.preparations?[index].amount??"",
                quantity:  widget.model?.preparations?[index].quantity??0,
                timesInDay:  widget.model?.preparations?[index].timesInDay??0,
                days:  widget.model?.preparations?[index].days??0,
                inn: widget.model?.preparations?[index].medicine?.inn,
                type:  widget.model?.preparations?[index].type??"",
                medicineId:  widget.model?.preparations?[index].medicineId??0);
          },);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTemplateCubit, CreateTemplateState>(
      listener: (context, state) {
        // if (state is CreateTemplateGetMedicineSuccess) {
        //   setState(() {
        //     medicineList = state.list;
        //   });
        // }
        if (state is CreateTemplateUploadSuccess) {
          context
              .read<HomeCubit>()
              .getTemplate(saved: "", sortBy: "", searchText: "");
          Navigator.pop(context);
        }
        if (state is UpdateTemplateUploadSuccess) {
          context
              .read<HomeCubit>()
              .getTemplate(saved: "", sortBy: "", searchText: "");
          Navigator.pop(context);
          Navigator.pop(context);
        }
        if (state is CreateTemplateUploadError) {
          toastification.show(
            style: ToastificationStyle.flat,
            context: context,
            alignment: Alignment.topCenter,
            title: Text(state.failure.errorMsg),
            autoCloseDuration: const Duration(seconds: 2),
            showProgressBar: false,
            primaryColor: Colors.white,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          );
        }
        if (state is UpdateTemplateUploadError) {
          toastification.show(
            style: ToastificationStyle.flat,
            context: context,
            alignment: Alignment.topCenter,
            title: Text(state.failure.errorMsg),
            autoCloseDuration: const Duration(seconds: 2),
            showProgressBar: false,
            primaryColor: Colors.white,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        if (state is CreateTemplateUploadLoading ||
            state is UpdateTemplateUploadLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            forceMaterialTransparency: true,
            title: Text(
              widget.model != null
                  ? LocaleKeys.create_template_edit_template.tr()
                  : LocaleKeys.create_template_create_template.tr(),
              style: TextStyle(
                  fontFamily: 'VelaSans',
                  fontSize: widget.model != null ? 20 : 26,
                  fontWeight: FontWeight.w800,
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
            child: Form(
              key: formKey,
              child: Column(
                spacing: Dimens.space10,
                children: [
                  SizedBox(),
                  TemplateItem(
                      title: LocaleKeys.create_template_title.tr(),
                      hint: LocaleKeys.create_template_write_here.tr(),
                      controller: textController,
                      validator: (String? value) {
                        if (value
                            .toString()
                            .isEmpty) {
                          return LocaleKeys.create_template_fill_the_blanks
                              .tr();
                        }
                        return null;
                      }),
                  TemplateItem(
                      title: LocaleKeys.create_template_diagnosis.tr(),
                      hint: LocaleKeys.create_template_write_here.tr(),
                      controller: diagnosisController,
                      validator: (String? value) {
                        if (value
                            .toString()
                            .isEmpty) {
                          return LocaleKeys.create_template_fill_the_blanks
                              .tr();
                        }
                        return null;
                      }),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Dimens.space20,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.create_template_mnn.tr(),
                              style: TextStyle(
                                  fontFamily: 'VelaSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: Dimens.space18,
                                  color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  showMedicine(
                                      ctx: context,
                                      model: (value) {
                                        preparation.add(Preparation(
                                            name: value.name ?? "",
                                            amount:
                                            "${value.prescription} ${value
                                                .volume}",
                                            quantity: 0,
                                            timesInDay: 0,
                                            days: 0,
                                            type: value.type ?? "",
                                            medicineId: value.id ?? 0,
                                            inn: value.inn));
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      medicine: List.generate(
                                        preparation.length,
                                            (index) =>
                                            MedicineModel(
                                                id: preparation[index]
                                                    .medicineId ?? 0,
                                                name: preparation[index].name,
                                                type: preparation[index].type),
                                      )),
                              child: SvgPicture.asset(
                                Assets.icons.plus,
                                height: Dimens.space30,
                                width: Dimens.space30,
                              ),
                            )
                          ],
                        ),
                        ...List.generate(
                          preparation.length,
                              (index) {
                            final textController = TextEditingController();
                            textController.text = "";
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: Dimens.space10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.space20,
                                    vertical: Dimens.space16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        preparation[index].name,
                                        style: TextStyle(
                                            fontFamily: 'VelaSans',
                                            fontSize: Dimens.space14,
                                            color: Colors.black),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          preparation.removeAt(index);
                                          setState(() {});
                                        },
                                        child: SvgPicture.asset(
                                          Assets.icons.minus,
                                          height: Dimens.space24,
                                          width: Dimens.space24,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if((preparation[index].inn?.length ?? 0) > 0)
                                  Text("MNN"),
                                if((preparation[index].inn?.length ?? 0) > 0)
                                  Wrap(

                                    runAlignment: WrapAlignment.start,

                                    runSpacing: Dimens.space10,
                                    spacing: Dimens.space10,

                                    children: List.generate(
                                      preparation[index].inn?.length ?? 0, (
                                        index2) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.backgroundColor,
                                            borderRadius: BorderRadius.circular(
                                                6)),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Dimens.space10,
                                          vertical: Dimens.space6,
                                        ),
                                        child: Text(
                                          preparation[index].inn?[index2] ?? "",
                                          style: TextStyle(
                                              fontFamily: 'VelaSans',
                                              fontSize: Dimens.space14,
                                              color: Colors.black),
                                        ),
                                      );
                                    },),
                                  ),

                                // AppTextField(
                                //    title: "Inn",
                                //     controller: TextEditingController(),
                                //     hintText: ""),
                                Row(
                                  spacing: Dimens.space10,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        // onTap: () {
                                        //   showMedicineTypeList(
                                        //     onChange: (value) {
                                        //       setState(() {
                                        //         preparation[index].type = value;
                                        //       });
                                        //     },
                                        //   );
                                        // },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimens.space20,
                                              vertical: Dimens.space16),
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundColor,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            spacing: Dimens.space10,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dataTranslate(
                                                    ctx: context,
                                                    model: checkMedicineType(
                                                        name: preparation[index]
                                                            .type)),
                                                style: GoogleFonts.ubuntu(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Dimens.space12),
                                              ),
                                              // Icon(
                                              //   CupertinoIcons.chevron_down,
                                              //   color: Colors.black,
                                              //   size: Dimens.space20,
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          double number = double.parse(
                                              preparation[index]
                                                  .amount
                                                  .replaceAll(
                                                  RegExp(r'[^0-9.]'), ''));
                                          String onlyText = preparation[index]
                                              .amount.replaceAll(
                                              RegExp(r'[0-9]'), '').trim();

                                          print(number); // Natija: 300
                                          showInputAmount(
                                            name: preparation[index].name,
                                            amount: number,
                                            onChange: (value) {
                                              preparation[index].amount =
                                              "$value $onlyText";
                                              setState(() {

                                              });
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimens.space20,
                                              vertical: Dimens.space16),
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundColor,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            spacing: Dimens.space10,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                preparation[index].amount,
                                                style: GoogleFonts.ubuntu(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: Dimens.space12),
                                              ),
                                              Icon(
                                                CupertinoIcons.chevron_down,
                                                color: Colors.black,
                                                size: Dimens.space20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: Dimens.space10,
                                  children: [
                                    Expanded(
                                      child: CupertinoNumberPicker(
                                        selectedNumber:
                                        preparation[index].quantity,
                                        onChanged: (int value) {
                                          setState(() {
                                            preparation[index].quantity = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoNumberPicker(
                                        selectedNumber:
                                        preparation[index].timesInDay,
                                        onChanged: (int value) {
                                          setState(() {
                                            preparation[index].timesInDay =
                                                value;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoNumberPicker(
                                        selectedNumber: preparation[index].days,
                                        onChanged: (int value) {
                                          setState(() {
                                            preparation[index].days = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  spacing: Dimens.space10,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          LocaleKeys.create_template_quantity
                                              .tr(),
                                          style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Dimens.space12),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          LocaleKeys.create_template_timesInDay
                                              .tr(),
                                          style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Dimens.space12),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          LocaleKeys.create_template_days.tr(),
                                          style: GoogleFonts.ubuntu(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Dimens.space12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  TemplateItem(
                      title: LocaleKeys.create_template_note.tr(),
                      hint: LocaleKeys.create_template_write_here.tr(),
                      controller: noteController,
                      validator: (String? value) {
                        if (value
                            .toString()
                            .isEmpty) {
                          return LocaleKeys.create_template_fill_the_blanks
                              .tr();
                        }
                        return null;
                      }),
                  SizedBox(
                    height: Dimens.space10,
                  ),
                  UniversalButton.filled(
                    cornerRadius: 15,
                    text: LocaleKeys.create_template_save_template.tr(),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (preparation.isEmpty) {
                          toastification.show(
                            style: ToastificationStyle.flat,
                            context: context,
                            alignment: Alignment.topCenter,
                            title: Text(LocaleKeys.texts_add_medicine.tr()),
                            autoCloseDuration: const Duration(seconds: 2),
                            showProgressBar: false,
                            primaryColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          );
                        } else {
                          String token =
                              await SecureStorage().read(key: "accessToken") ??
                                  "";
                          Map<String, dynamic> decodedToken =
                          JwtDecoder.decode(token);
                          String uuid = decodedToken["sub"];

                          if (widget.model != null) {
                            // debugPrint("this is saved data${widget.model?.saved??false}");

                            context.read<CreateTemplateCubit>().updateTemplate(
                                model: TemplateModel(
                                    id: widget.model?.id ?? 0,
                                    name: textController.text.trim(),
                                    diagnosis: diagnosisController.text.trim(),
                                    preparations: List.generate(preparation.length,  (index) {
                                      return TemplatePreparation(
                                        days: preparation[index].days,
                                        type: preparation[index].type,
                                        name: preparation[index].name,
                                        amount: preparation[index].amount,
                                        medicineId: preparation[index].medicineId,
                                        quantity: preparation[index].quantity,
                                        timesInDay: preparation[index].timesInDay,
                                      );
                                    },),
                                    note: noteController.text.trim(),
                                    doctorId: uuid,
                                    saved: widget.model?.saved ?? false));
                          } else {
                            context.read<CreateTemplateCubit>().uploadTemplate(
                                model: UploadTemplateModel(
                                  // id: id,
                                    name: textController.text.trim(),
                                    diagnosis: diagnosisController.text.trim(),
                                    preparations: preparation,
                                    note: noteController.text.trim(),
                                    saved: false,
                                    doctorId: uuid));
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: Dimens.space20,
                  ),
                ],
              ).paddingSymmetric(horizontal: Dimens.space20),
            ),
          ),
        );
      },
    );
  }

  Widget TemplateItem({required String title,
    required String hint,
    required TextEditingController controller,
    required FormFieldValidator<String?>? validator}) {
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
                color: Colors.black),
          ),
          AppTextField(
            controller: controller,
            hintText: hint,
            validator: validator,
          ),
        ],
      ),
    );
  }

  // showMedicineList({required ValueChanged<MedicineModel> onChange}) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     enableDrag: true,
  //     showDragHandle: true,
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         constraints: BoxConstraints(
  //             maxHeight: MediaQuery.sizeOf(context).height * 0.8),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: List.generate(
  //               medicineList.length,
  //               (index) {
  //                 return ListTile(
  //                   onTap: () {
  //                     onChange(medicineList[index]);
  //                     Navigator.pop(context);
  //                   },
  //                   title: Text(medicineList[index].name ?? ""),
  //                 );
  //               },
  //             ),
  //           ).paddingOnly(bottom: 20),
  //         ),
  //       );
  //     },
  //   );
  // }
  void showInputAmount({required String name,
    required double amount,
    required ValueChanged<double> onChange}) async {
    final textController = TextEditingController();
    final quantForm = GlobalKey<FormState>();
    textController.text = amount.toString();
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Form(
          key: quantForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.space20,
            children: [
              Text(
                name,
                style: TextStyle(
                    fontSize: Dimens.space18, fontWeight: FontWeight.w500),
              ),
              AppTextField(
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                validator: (value) {
                  if (value
                      .toString()
                      .isEmpty) {
                    return "kamida 1 ta bo'lishi kerak";
                  }
                  int number = int.tryParse(value.toString()) ?? 0;
                  if (number < 1) {
                    return "0 bo'lmasligi kerak";
                  }
                  return null;
                },
                maxLen: 5,
                controller: textController,
                hintText: "1",
              ),
              UniversalButton.filled(
                text: "Сохранять",
                onPressed: () {
                  if (quantForm.currentState!.validate()) {
                    double number =
                        double.tryParse(textController.text.toString()) ?? 1;
                    onChange(number);
                    Navigator.pop(context);
                  }
                },
                fontSize: Dimens.space14,
                cornerRadius: Dimens.space20,
              ),
              SizedBox(
                height: Dimens.space50,
              )
            ],
          ).paddingOnly(
              left: Dimens.space30,
              right: Dimens.space30,
              top: Dimens.space20,
              bottom: MediaQuery
                  .viewInsetsOf(context)
                  .bottom),
        );
      },
    );
  }

  showMedicineTypeList({required ValueChanged<String> onChange}) {
    List<String> types = ["PILLS", "TYPE2", "TYPE3"];
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery
                  .sizeOf(context)
                  .height * 0.8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                types.length,
                    (index) {
                  return ListTile(
                    onTap: () {
                      onChange(types[index]);
                      Navigator.pop(context);
                    },
                    title: Text(types[index]),
                  );
                },
              ),
            ).paddingOnly(bottom: 20),
          ),
        );
      },
    );
  }
}
