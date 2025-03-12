import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';

import '../constant/diments.dart';
import '../styles/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLen,
    this.isEnabled,
    this.withDecoration = true,
    this.isDense,
    this.maxLines = 1,
    this.minLines = 1,
    this.suffix,
    this.suffixIcon,
    this.title,
    this.prefix,
    this.prefixIcon,
    this.formatter,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.hintColor,
    this.textColor,
    this.isSearch = false,
    this.padding = const EdgeInsets.all(0.0),
    this.onComplete,
    this.obscureText = false,
    this.titleStyle,
    this.titleOptional,
    this.isOnTapOutside = true,
    this.backgroundColor,
  });

  final TextEditingController controller;
  final bool? isEnabled;
  final bool? isDense;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? prefixIcon;
  final String? hintText;
  final String? title;
  final int? maxLen;
  final int? maxLines;
  final int? minLines;
  final bool withDecoration;
  final List<TextInputFormatter>? formatter;
  final FormFieldValidator<String?>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onComplete;
  final bool readOnly;
  final Color? hintColor;
  final Color? textColor;
  final Color? backgroundColor;
  final bool isSearch;
  final EdgeInsets padding;
  final bool obscureText;
  final TextStyle? titleStyle;
  final String? titleOptional;
  final bool isOnTapOutside;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Row(
              children: [
                SizedBox(
                  width: Dimens.space4,
                ),
                Text(
                  widget.title!,
                  style: widget.titleStyle??TextStyle(
                    fontSize: Dimens.space16,
                    fontWeight: (widget.titleStyle == null)
                        ? FontWeight.w500
                        : FontWeight.w600,
                  ),
                ),
                SizedBox(width: Dimens.space8),
                Text(
                  widget.titleOptional != null
                      ? widget.titleOptional.toString()
                      : '',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey),
                ),
              ],
            ),
          SizedBox(height: Dimens.space5),
          TextFormField(

            autofocus: false,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              // FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            validator: widget.validator,
            obscureText: widget.obscureText,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.controller,
            maxLength: widget.maxLen,
            minLines: widget.minLines,
            style: TextStyle(
              color: widget.textColor,
              fontSize: Dimens.space14,
            ),
            onEditingComplete: () {
              if (widget.onComplete != null) {
                widget.onComplete!("");
              }
            },
            enabled: widget.isEnabled,
            focusNode: focusNode,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            onTapOutside: (tab) =>
                widget.isOnTapOutside ? focusNode.unfocus() : null,
            inputFormatters: widget.formatter,
            decoration: InputDecoration(

              errorMaxLines: 5,
              errorStyle: TextStyle(
                fontSize: Dimens.space12,

                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
              prefix: widget.prefix,
              suffix: widget.suffix,
              counterText: "",
              suffixIcon: widget.suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Dimens.space20,
                vertical: Dimens.space16,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: Dimens.space14,
                color: widget.hintColor != null
                    ? Colors.black
                    : focusNode.hasFocus
                        ? Colors.grey.shade500
                        : Colors.grey.shade500,
              ),
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.prefixIcon!,
                    ],
                  ).paddingOnly(left: Dimens.space10),
              filled: true,
              isDense: widget.isDense,
              fillColor: _getFillColor(),
              border: _border(),
              disabledBorder: _border(),
              errorBorder: _errorBorder(),
              focusedBorder: _focusedBorder(),
              enabledBorder: _border(),
              focusedErrorBorder: _errorBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getFillColor() {
    if (focusNode.hasFocus) {
      return AppColors.blueColor.withAlpha(30);
    } else {
      return widget.backgroundColor != null
          ? widget.backgroundColor!
          : AppColors.backgroundColor;
    }
  }

  OutlineInputBorder _focusedBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.cornerRadius),
        borderSide: BorderSide(width: 1, color: AppColors.blueColor),
      );

  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.cornerRadius),
        borderSide: const BorderSide(width: 0, color: Colors.transparent),
      );

  OutlineInputBorder _errorBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.cornerRadius),
        borderSide: BorderSide(width: 1, color: Colors.redAccent),
      );
}
