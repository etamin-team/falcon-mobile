import 'package:flutter/material.dart';
import 'package:wm_doctor/core/constant/diments.dart';

import '../styles/app_colors.dart';

class UniversalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final double height;
  final double borderSide;
  final double cornerRadius;
  final double width;
  final bool outlined;
  final Widget? icon;
  final String svg;
  final Color svgColor;
  final bool centerGravity;
  final bool enabled;
  final EdgeInsets margin;
  final FontWeight textFontWeight;
  final bool isDisabled;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          overlayColor: isDisabled && !outlined
              ? Colors.transparent
              : outlined
                  ? AppColors.blueColor
                  : AppColors.white,
          shadowColor: Colors.transparent,
          backgroundColor: outlined
              ? backgroundColor
              : isDisabled
                  ? Colors.grey.shade300
                  : backgroundColor,
          shape: RoundedRectangleBorder(
            side: outlined
                ? BorderSide(width: borderSide, color: borderColor)
                : BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(cornerRadius),
            ),
          ),
        ),
        onPressed: (!enabled)
            ? null
            : onPressed,
        child: Row(
          spacing: Dimens.space10,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(text!="")
            Text(
              maxLines: 2,
              textAlign: TextAlign.center,
              text,
              style: TextStyle(
                fontFamily: 'VelaSans',
                fontWeight: textFontWeight,
                fontSize: fontSize,
                color: isDisabled ? Colors.grey.shade700 : textColor,
              ),
            ),
            if(icon!=null)
              icon!

          ],
        ),
      ),
    );
  }

  const UniversalButton.filled({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.blueColor,
    this.outlined = false,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.height = 55,
    this.icon,
    this.svg = "",
    this.centerGravity = true,
    this.enabled = true,
    this.margin = EdgeInsets.zero,
    this.svgColor = Colors.white,
    this.isDisabled = false,
    this.width = double.infinity,
    this.textFontWeight = FontWeight.bold,
    this.borderSide = 1,
    this.cornerRadius = 30,  this.borderColor= Colors.black,
  });

  const UniversalButton.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.outlined = true,
    this.textColor = AppColors.black,
    this.fontSize = 16,
    this.height = 55,
    this.icon,
    this.svg = "",
    this.centerGravity = true,
    this.enabled = true,
    this.margin = EdgeInsets.zero,
    this.svgColor = Colors.white,
    this.textFontWeight = FontWeight.bold,
    this.width = double.infinity,
    this.isDisabled = false,
    this.borderSide = 1,
    this.cornerRadius = 30,
    this.borderColor= Colors.black
  });
}
