import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    // useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.inter().fontFamily,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: AppColors.neutral800,
      ),
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      surfaceTint: Colors.white,
      primary: AppColors.primary,
    ),
    cardColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      prefixStyle: TextStyle(color: AppColors.woodSmoke950),
      border: OutlineInputBorder(
        gapPadding: 16,
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        borderSide: BorderSide(color: AppColors.woodSmoke100, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        gapPadding: 16,

        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.woodSmoke100, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: 16,

        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        gapPadding: 16,

        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        gapPadding: 16,

        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      hintStyle: TextStyle(
        color: AppColors.woodSmoke400,
        fontSize: 14.0,
        height: 1.3,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(
        color: AppColors.woodSmoke400,
        fontSize: 14.0,
        height: 1.3,
        fontWeight: FontWeight.w400,
      ),
      // filled: true,
      fillColor: Colors.grey[100],
      // Background color
      contentPadding: EdgeInsets.symmetric(
        vertical: 10.0,
        // horizontal: 12.0,
      ), // Padding inside the field
    ),
    buttonTheme: ButtonThemeData(
      splashColor: Colors.grey.shade300.withOpacity(0.4),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return Colors.grey.shade300;
      }),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((
          Set<MaterialState> states,
        ) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey.shade400.withOpacity(
              0.3,
            ); // Splash color for TextButton
          }
          return null; // Defer to the theme's splash color
        }),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.woodSmoke50,
      space: 0,
      thickness: 1,
    ),
    dividerColor: AppColors.woodSmoke50,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.neutral500,
      selectedLabelStyle: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.6,
      ),
      unselectedLabelStyle: TextStyle(
        color: AppColors.neutral500,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.6,
      ),
    ),

    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      splashBorderRadius: BorderRadius.circular(8),
      labelPadding: EdgeInsets.symmetric(horizontal: 2),
      indicatorColor: AppColors.primary,
    ),

    textTheme: TextTheme(
      displayLarge: AppTypography.bold32.copyWith(
        color: AppColors.woodSmoke950,
      ),
      displayMedium: AppTypography.bold24.copyWith(
        color: AppColors.woodSmoke950,
      ),
      displaySmall: AppTypography.bold20.copyWith(
        color: AppColors.woodSmoke950,
      ),
      headlineLarge: AppTypography.bold20.copyWith(
        color: AppColors.woodSmoke950,
      ),
      headlineMedium: AppTypography.medium18.copyWith(
        color: AppColors.woodSmoke950,
      ),
      headlineSmall: AppTypography.medium16.copyWith(
        color: AppColors.woodSmoke950,
      ),
      titleLarge: AppTypography.medium16.copyWith(
        color: AppColors.woodSmoke950,
      ),
      titleMedium: AppTypography.regular14.copyWith(
        color: AppColors.woodSmoke950,
      ),
      titleSmall: AppTypography.regular12.copyWith(
        color: AppColors.woodSmoke950,
      ),
      bodyLarge: AppTypography.regular14.copyWith(
        color: AppColors.woodSmoke950,
      ),
      bodyMedium: AppTypography.regular12,
      bodySmall: AppTypography.regular10.copyWith(
        color: AppColors.woodSmoke950,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      dragHandleColor: AppColors.woodSmoke100, // Color of the pill
      dragHandleSize: Size(56, 6),
      showDragHandle: true, // Width and height of the pill
    ),
  );
}
