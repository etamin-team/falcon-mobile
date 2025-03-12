import 'package:flutter/services.dart';


class CustomPhoneFormatter extends TextInputFormatter {
  final String prefix = "+998 ";

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Agar foydalanuvchi `+998 ` ni o‘chirishga harakat qilsa, eski qiymatni qaytarib beramiz
    if (!newValue.text.startsWith(prefix)) {
      return oldValue;
    }

    // Foydalanuvchi kiritgan raqamlarni olish va bo‘sh joylarni to‘g‘rilash
    String digits =
        newValue.text.replaceAll(RegExp(r'\D'), '').replaceFirst('998', '');

    // Maksimal uzunlikni cheklash (9 ta raqam)
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    // Formatlash: +998 99 123 45 67
    String formattedText = prefix;
    if (digits.length >= 2) {
      formattedText += '${digits.substring(0, 2)} ';
    }
    if (digits.length >= 5) {
      formattedText += '${digits.substring(2, 5)} ';
    }
    if (digits.length >= 7) {
      formattedText += '${digits.substring(5, 7)} ';
    }
    if (digits.length > 7) {
      formattedText += digits.substring(7);
    }

    // Kursorni to‘g‘ri joylashtirish
    return TextEditingValue(
      text: formattedText.trim(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
