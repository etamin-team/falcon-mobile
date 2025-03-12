import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    appBarTheme: ApBarTheme.appBarTheme,
    cardColor: AppColors.white,
    shadowColor: Colors.black26,
    colorScheme:
        const ColorScheme.light().copyWith(primary: AppColors.primaryColor),
    scaffoldBackgroundColor: AppColors.white,
    useMaterial3: true,
    textTheme: /*Typography.englishLike2021.apply(fontSizeFactor: 1.sp)*/
        TextTheme(
      displayLarge: TextStyle(fontSize: 26,fontFamily: 'VelaSans'),
      displayMedium:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'VelaSans'),
      titleMedium:
          TextStyle(fontSize: 16, fontWeight: FontWeight.normal,fontFamily: 'VelaSans'),
      titleSmall: TextStyle(fontSize: 14,fontFamily: 'VelaSans'),
      titleLarge: TextStyle(fontFamily: 'VelaSans'),
      bodyLarge: TextStyle(fontFamily: 'VelaSans'),
      bodyMedium: TextStyle(fontFamily: 'VelaSans'),
      bodySmall: TextStyle(fontFamily: 'VelaSans'),
      displaySmall: TextStyle(fontFamily: 'VelaSans'),
      headlineLarge: TextStyle(fontFamily: 'VelaSans'),
      headlineMedium: TextStyle(fontFamily: 'VelaSans'),
      headlineSmall: TextStyle(fontFamily: 'VelaSans'),
      labelLarge: TextStyle(fontFamily: 'VelaSans'),
      labelMedium: TextStyle(fontFamily: 'VelaSans'),
      labelSmall: TextStyle(fontFamily: 'VelaSans'),
    ),
    dividerColor: AppColors.lightGrey,
    fontFamily: "VelaSans",
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(Color(0xFF216BF4)), // Thumb rangi
      thickness: WidgetStateProperty.all(0.0), // Thumbning qalinligi
      radius: Radius.circular(8), // Thumbning burchak radiusi
      trackColor: WidgetStateProperty.all(Color(0x330026A2)),
    ),
  );
}

class ApBarTheme {
  static final appBarTheme = AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.transparent,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      titleTextStyle: TextStyle(
        fontFamily: 'VelaSans',
          fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
      elevation: 0,
      shadowColor: Colors.black26);
}
