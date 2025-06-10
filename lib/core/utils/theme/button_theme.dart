//Filled Button Theme
import 'package:flutter/material.dart';
import 'package:sylonow_vendor/core/utils/constants/app_colors.dart';
import 'package:sylonow_vendor/core/utils/constants/size.dart';

class TFilledButtonTheme {
  TFilledButtonTheme._();

  static FilledButtonThemeData lightFilledButtonTheme = FilledButtonThemeData(

    style: FilledButton.styleFrom(
      foregroundColor: Colors.white,
      fixedSize: const Size(double.infinity, 50),
      backgroundColor: TColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.lg),
      ),
    ),
  );
}
