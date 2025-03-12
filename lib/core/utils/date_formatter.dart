import 'package:flutter/services.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Agar foydalanuvchi sanani to'g'ri formatda kiritayotgan bo'lsa
    if (text.length == 2 || text.length == 5) {
      text = '$text/'; // Slash qo'shish
    }

    // Validatsiya: 01-31 kun va 01-12 oy
    if (text.length == 10) {
      List<String> dateParts = text.split('/');
      if (dateParts.length == 3) {
        int day = int.tryParse(dateParts[0]) ?? 0;
        int month = int.tryParse(dateParts[1]) ?? 0;
        int year = int.tryParse(dateParts[2]) ?? 0;

        // 1-31 kun va 1-12 oy
        if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1000 || year > 9999) {
          return oldValue; // Invalid day, month or year
        }

        // Fevralda kabis yilini tekshirish
        List<int> maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        if (month == 2) {
          if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
            maxDaysInMonth[1] = 29; // Kabis yil fevralda 29 kun
          }
        }

        // Agar kiritilgan kun maksimal kundan katta bo'lsa
        if (day > maxDaysInMonth[month - 1]) {
          return oldValue; // Invalid day for the given month
        }
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
