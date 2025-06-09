import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/core/utils/data_translate.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/page/sign_up_success.dart';
import 'package:wm_doctor/features/regions/presentation/page/regions_dialog.dart';
import 'package:wm_doctor/features/workplace/presentation/page/workplace_dialog.dart';

import '../../../../../core/constant/diments.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/utils/text_mask.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/universal_button.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../../domain/utility/doctor_level.dart';
import '../../domain/utility/doctor_type.dart';
import '../widgets/language.dart';

class SignUpData extends StatefulWidget {
  final String number;

  const SignUpData({super.key, required this.number});

  @override
  State<SignUpData> createState() => _SignUpDataState();
}

class _SignUpDataState extends State<SignUpData> {
  DateTime? selectedDate;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();
  final workplaceController = TextEditingController();
  final doctorTypeController = TextEditingController();
  final doctorLevelController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final lastNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final birthDateController = TextEditingController();
  bool isMen = true;
  bool isObscureText = true;
  LanguageModel city = LanguageModel(uz: "", ru: "");
  // LanguageModel city = LanguageModel(uz: "", ru: "", en: "");

  LanguageModel doctorTypeName = LanguageModel(uz: "", ru: "");
  // LanguageModel doctorTypeName = LanguageModel(uz: "", ru: "", en: "");
  LanguageModel doctorPosition = LanguageModel(uz: "", ru: "");
  // LanguageModel doctorPosition = LanguageModel(uz: "", ru: "", en: "");
  String workplace = "";

  int districtId = 0;
  int workplaceId = 0;

  @override
  void initState() {
    context.read<SignUpCubit>().getSignUpData();
    numberController.text = "+998${widget.number}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addressController.text = dataTranslate(ctx: context, model: city);
    doctorTypeController.text =
        dataTranslate(ctx: context, model: doctorTypeName);
    doctorLevelController.text =
        dataTranslate(ctx: context, model: doctorPosition);
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          saveLogin();
        }
        if (state is SignUpError) {
          toastification.show(
            style: ToastificationStyle.flat,
            context: context,
            alignment: Alignment.topCenter,
            title: Text(LocaleKeys.sign_up_sign_up_error.tr()),
            autoCloseDuration: const Duration(seconds: 2),
            showProgressBar: false,
            primaryColor: Colors.white,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        if (state is SignUpLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFEBF2FA), // Yuqori qism uchun rang
                Color(0xFFD7E9F6), // Yuqori qism uchun rang
                Color(0xFF98B0F9), // Pastki qism uchun rang
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: CupertinoColors.transparent,
            appBar: AppBar(
              // title: Image.asset(
              //   Assets.images.logo.path,
              //   height: 40,
              // ),
              toolbarHeight: Dimens.space100,
              automaticallyImplyLeading: false,
              forceMaterialTransparency: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    showLanguageChoice(ctx: context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.white),
                    padding: EdgeInsets.all(Dimens.space16),
                    margin: EdgeInsets.only(right: Dimens.space20),
                    child: SvgPicture.asset(Assets.icons.global),
                  ),
                )
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(40)),
              padding: EdgeInsets.only(
                  top: Dimens.space30,
                  bottom: Dimens.space30,
                  left: Dimens.space20,
                  right: Dimens.space5),
              margin: EdgeInsets.only(
                  top: Dimens.space5,
                  bottom: Dimens.space30,
                  left: Dimens.space20,
                  right: Dimens.space20),
              child: Scrollbar(
                trackVisibility: true,
                thickness: 5,
                radius: Radius.circular(5), // T
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      spacing: Dimens.space20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.sign_up_about.tr(),
                          style: TextStyle(
                              fontFamily: "VelaSans",
                              fontWeight: FontWeight.w400,
                              fontSize: Dimens.space30),
                        ),
                        AppTextField(
                            keyboardType: TextInputType.name,
                            formatter: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                            title: LocaleKeys.sign_up_firstname.tr(),
                            controller: nameController,
                            validator: (value) {
                              if (value.toString().length < 3) {
                                return LocaleKeys.sign_up_enter_firstname.tr();
                              }
                              return null;
                            },
                            hintText: "Камрон"),
                        AppTextField(
                            keyboardType: TextInputType.name,
                            formatter: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                            title: LocaleKeys.sign_up_lastname.tr(),
                            validator: (value) {
                              if (value.toString().length < 3) {
                                return LocaleKeys.sign_up_enter_lastname.tr();
                              }
                              return null;
                            },
                            controller: lastNameController,
                            hintText: "Исламов"),
                        AppTextField(
                            keyboardType: TextInputType.name,
                            formatter: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                            title: LocaleKeys.sign_up_middleName.tr(),
                            controller: middleNameController,
                            hintText: "Козимович"),
                        GestureDetector(
                          onTap: () {
                            showDatePickerBottomSheet(context);
                          },
                          child: AppTextField(
                              textColor: Colors.black,
                              isEnabled: false,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return LocaleKeys.sign_up_enter_middleName
                                      .tr();
                                }
                                return null;
                              },
                              keyboardType: TextInputType.datetime,
                              formatter: [
                                TextMask(pallet: '##/##/####'),
                                // DateFormatter(),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              suffixIcon: InkWell(
                                // onTap: () {
                                //   showDatePickerBottomSheet(context);
                                // },
                                child: SvgPicture.asset(
                                  Assets.icons.calendar,
                                  height: Dimens.space14,
                                  width: Dimens.space14,
                                ).paddingAll(value: Dimens.space10),
                              ),
                              title: LocaleKeys.sign_up_birthdate.tr(),
                              controller: birthDateController,
                              hintText: "29/11/2001"),
                        ),
                        Column(
                          spacing: Dimens.space5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.sign_up_gender.tr(),
                              style: TextStyle(
                                fontSize: Dimens.space16,
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingOnly(left: Dimens.space4),
                            Row(
                              spacing: Dimens.space10,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: UniversalButton.filled(
                                    fontSize: Dimens.space14,
                                    textColor: isMen
                                        ? AppColors.white
                                        : Colors.grey.shade700,
                                    textFontWeight: FontWeight.w400,
                                    cornerRadius: 15,
                                    backgroundColor: isMen
                                        ? AppColors.blueColor
                                        : Colors.grey.shade200,
                                    text: "Мужской",
                                    onPressed: () {
                                      setState(() {
                                        isMen = true;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: UniversalButton.filled(
                                    fontSize: Dimens.space14,
                                    textColor: !isMen
                                        ? AppColors.white
                                        : Colors.grey.shade700,
                                    textFontWeight: FontWeight.w400,
                                    cornerRadius: 15,
                                    backgroundColor: !isMen
                                        ? AppColors.blueColor
                                        : Colors.grey.shade200,
                                    text: "Женский",
                                    onPressed: () {
                                      setState(() {
                                        isMen = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        CustomDropDownCard(
                          title: LocaleKeys.sign_up_region.tr(),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return LocaleKeys.sign_up_select_address.tr();
                            }
                            return null;
                          },
                          onClick: () {
                            showRegions(
                              ctx: context,
                              onChange: (value) {
                                setState(() {
                                  city = value;
                                  addressController.text =
                                      dataTranslate(ctx: context, model: city);
                                });
                                if (formKey.currentState!.validate()) {}
                              },
                              districtId: (value) {
                                setState(() {
                                  districtId = value;
                                });
                                if (formKey.currentState!.validate()) {}
                              },
                            );
                          },
                          textController: addressController,
                          hint: LocaleKeys.sign_up_select_address.tr(),
                        ),
                        CustomDropDownCard(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return LocaleKeys.sign_up_select_workplace.tr();
                            }
                            return null;
                          },
                          title: LocaleKeys.sign_up_workplace.tr(),
                          onClick: () {
                            showWorkplaceDialog(
                              ctx: context,
                              name: (value) {
                                setState(() {
                                  workplace = value;
                                  workplaceController.text = value;
                                });
                                if (formKey.currentState!.validate()) {}
                              },
                              id: (value) {
                                setState(() {
                                  workplaceId = value;
                                });
                                if (formKey.currentState!.validate()) {}
                              },
                            );
                          },
                          textController: workplaceController,
                          hint: LocaleKeys.sign_up_select_workplace.tr(),
                        ),
                        CustomDropDownCard(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return LocaleKeys.sign_up_select_type.tr();
                            }
                            return null;
                          },
                          title: LocaleKeys.sign_up_doctor_type.tr(),
                          onClick: () {
                            showDoctorTypeList(
                              ctx: context,
                              onchange: (value) {
                                setState(() {
                                  doctorTypeName = value;
                                  doctorTypeController.text = dataTranslate(
                                      ctx: context, model: doctorTypeName);
                                });
                                if (formKey.currentState!.validate()) {}
                              },
                              realType: (String value) {
                                setState(() {});
                              },
                            );
                          },
                          textController: doctorTypeController,
                          hint: LocaleKeys.sign_up_select_type.tr(),
                        ),
                        CustomDropDownCard(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return LocaleKeys.sign_up_select_position.tr();
                            }
                            return null;
                          },
                          title: LocaleKeys.sign_up_doctor_position.tr(),
                          onClick: () {
                            showDoctorPositionList(
                              ctx: context,
                              onchange: (value) {
                                setState(() {
                                  doctorPosition = value;
                                  doctorLevelController.text = dataTranslate(
                                      ctx: context, model: doctorPosition);
                                });
                                if (formKey.currentState!.validate()) {}
                              },
                            );
                          },
                          textController: doctorLevelController,
                          hint: LocaleKeys.sign_up_select_position.tr(),
                        ),
                        AppTextField(
                            readOnly: true,
                            keyboardType: TextInputType.phone,
                            formatter: [
                              TextMask(pallet: '+998 ## ### ## ##'),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\+?[0-9\s]*$'),
                                  replacementString: ""),
                              LengthLimitingTextInputFormatter(17),
                            ],
                            title: LocaleKeys.sign_up_phone_number_login.tr(),
                            controller: numberController,
                            hintText: "+998"),
                        AppTextField(
                            maxLen: 25,
                            validator: (value) {
                              if (value.toString().length < 8) {
                                return LocaleKeys.sign_up_enter_password.tr();
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(isObscureText
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye),
                              onPressed: () {
                                setState(() {
                                  isObscureText = !isObscureText;
                                });
                              },
                            ),
                            obscureText: isObscureText,
                            keyboardType: TextInputType.visiblePassword,
                            formatter: [
                              // TextMask(pallet: '+998 ## ### ## ##'),
                              // FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9\s]*$'),
                              //     replacementString: ""),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            title: LocaleKeys.sign_up_password.tr(),
                            controller: passwordController,
                            hintText: "********"),
                        AppTextField(
                            validator: (value) {
                              if (value.toString() != passwordController.text) {
                                return LocaleKeys.sign_up_enter_rePassword.tr();
                              }

                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(isObscureText
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye),
                              onPressed: () {
                                setState(() {
                                  isObscureText = !isObscureText;
                                });
                              },
                            ),
                            obscureText: isObscureText,
                            keyboardType: TextInputType.visiblePassword,
                            formatter: [
                              // TextMask(pallet: '+998 ## ### ## ##'),
                              // FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9\s]*$'),
                              //     replacementString: ""),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            title: LocaleKeys.sign_up_rePassword.tr(),
                            controller: rePasswordController,
                            hintText: "********"),
                        SizedBox(),
                        Row(
                          spacing: Dimens.space10,
                          children: [
                            Expanded(
                              flex: 1,
                              child: UniversalButton.outline(
                                height: Dimens.space60,
                                icon: Icon(
                                  CupertinoIcons.arrow_left,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                text: "",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: UniversalButton.filled(
                                height: Dimens.space60,
                                fontSize: Dimens.space14,
                                // icon: Icon(
                                //   CupertinoIcons.arrow_right,
                                //   color: Colors.white,
                                //   size: 25,
                                // ),
                                text: LocaleKeys.sign_up_continue.tr(),
                                textFontWeight: FontWeight.w400,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<SignUpCubit>().signUp(
                                        data: {
                                          "firstName":
                                              nameController.text.trim(),
                                          "lastName":
                                              lastNameController.text.trim(),
                                          "middleName":
                                              middleNameController.text.trim(),
                                          "phoneNumber": numberController.text
                                              .trim()
                                              .substring(4),
                                          "phonePrefix": numberController.text
                                              .substring(0, 4)
                                              .replaceAll("+", ""),
                                          "number": numberController.text
                                              .trim()
                                              .replaceAll("+", ""),
                                          "password":
                                              passwordController.text.trim(),
                                          "birthDate": DateFormat('yyyy-MM-dd')
                                              .format(selectedDate!),
                                          "gender": isMen ? "MALE" : "FEMALE",
                                          "workPlaceId": workplaceId,
                                          "fieldName":
                                              doctorTypeName.ru.toUpperCase(),
                                              // doctorTypeName.en.toUpperCase(),
                                          "position": doctorPosition.uz,
                                          "districtId": districtId
                                        },
                                        number: numberController.text
                                            .trim()
                                            .replaceAll(" ", "")
                                            .replaceAll("+", ""),
                                        password:
                                            passwordController.text.trim());
                                  } else {
                                    toastification.show(
                                      style: ToastificationStyle.flat,
                                      context: context,
                                      alignment: Alignment.topCenter,
                                      title: Text(
                                        "Пожалуйста, введите свои данные полностью.",
                                        maxLines: 5,
                                      ),
                                      autoCloseDuration:
                                          const Duration(seconds: 3),
                                      showProgressBar: false,
                                      primaryColor: Colors.white,
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).paddingOnly(right: Dimens.space14),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showDatePickerBottomSheet(BuildContext ctx) async {
    if (birthDateController.text.length == 10) {
      DateFormat format = DateFormat("dd/MM/yyyy");
      selectedDate = format.parse(birthDateController.text.toString());
    }
    DateTime dateTime = DateTime(2024);
    if (selectedDate != null) {
      dateTime = selectedDate!;
    }
    return showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      // BottomSheet o'lchamini moslashuvchan qiladi
      backgroundColor: Colors.white,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      // ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                LocaleKeys.sign_up_select_date.tr(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime:
                      selectedDate == null ? DateTime(2024) : selectedDate!,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime(2024),
                  onDateTimeChanged: (DateTime newDate) {
                    dateTime = newDate;
                  },
                ),
              ),
              CupertinoButton(
                child: Text(
                  LocaleKeys.sign_up_save.tr(),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = dateTime;
                    birthDateController.text =
                        DateFormat('dd/MM/yyyy').format(selectedDate!);
                  });
                  if (formKey.currentState!.validate()) {}
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  void saveLogin() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => SignUpSuccessPage(
                title: LocaleKeys.sign_up_sign_up_title.tr(),
                text: LocaleKeys.sign_up_sign_up_text.tr(),
              )),
      (route) => false,
    );
  }

  Widget CustomDropDownCard(
      {required TextEditingController textController,
      required String title,
      required String hint,
      required VoidCallback onClick,
      required FormFieldValidator<String?>? validator}) {
    return GestureDetector(
      onTap: onClick,
      child: AppTextField(
        isEnabled: false,
        textColor: Colors.black,
        controller: textController,
        hintText: hint,
        title: title,
        validator: validator,
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
      ),
    );
  }
}
