import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'theme_config.freezed.dart';
part 'theme_config.g.dart';

@freezed
class ThemeConfig with _$ThemeConfig {
  const factory ThemeConfig({
    required String id,
    required String configName,
    required bool isActive,
    
    // Primary Brand Colors
    required String primaryColor,
    required String primaryLight,
    required String primaryDark,
    required String primarySurface,
    
    // Secondary Colors
    required String secondaryColor,
    required String secondaryLight,
    required String secondaryDark,
    
    // Accent Colors
    required String accentPink,
    required String accentPurple,
    required String accentBlue,
    required String accentTeal,
    
    // Status Colors
    required String successColor,
    required String successLight,
    required String successDark,
    required String errorColor,
    required String errorLight,
    required String errorDark,
    required String warningColor,
    required String warningLight,
    required String warningDark,
    required String infoColor,
    required String infoLight,
    required String infoDark,
    
    // Background and Surface Colors
    required String backgroundColor,
    required String surfaceColor,
    required String cardColor,
    required String dividerColor,
    
    // Text Colors
    required String textPrimaryColor,
    required String textSecondaryColor,
    required String textDisabledColor,
    required String textOnPrimary,
    required String textOnSurface,
    
    // Border Colors
    required String borderColor,
    
    // Shadow Colors
    required String shadowColor,
    required String elevationShadow,
    
    // Metadata
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    required int version,
  }) = _ThemeConfig;

  factory ThemeConfig.fromJson(Map<String, dynamic> json) => _$ThemeConfigFromJson(json);
}

// Extension to convert hex strings to Flutter Color objects
extension ThemeConfigColors on ThemeConfig {
  // Helper method to convert hex string to Color
  Color _hexToColor(String hex) {
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    
    // Handle both RGB (6 chars) and ARGB (8 chars) formats
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add full opacity if not specified
    }
    
    return Color(int.parse(hex, radix: 16));
  }

  // Primary Colors
  Color get primaryColorValue => _hexToColor(primaryColor);
  Color get primaryLightValue => _hexToColor(primaryLight);
  Color get primaryDarkValue => _hexToColor(primaryDark);
  Color get primarySurfaceValue => _hexToColor(primarySurface);
  
  // Secondary Colors
  Color get secondaryColorValue => _hexToColor(secondaryColor);
  Color get secondaryLightValue => _hexToColor(secondaryLight);
  Color get secondaryDarkValue => _hexToColor(secondaryDark);
  
  // Accent Colors
  Color get accentPinkValue => _hexToColor(accentPink);
  Color get accentPurpleValue => _hexToColor(accentPurple);
  Color get accentBlueValue => _hexToColor(accentBlue);
  Color get accentTealValue => _hexToColor(accentTeal);
  
  // Status Colors
  Color get successColorValue => _hexToColor(successColor);
  Color get successLightValue => _hexToColor(successLight);
  Color get successDarkValue => _hexToColor(successDark);
  Color get errorColorValue => _hexToColor(errorColor);
  Color get errorLightValue => _hexToColor(errorLight);
  Color get errorDarkValue => _hexToColor(errorDark);
  Color get warningColorValue => _hexToColor(warningColor);
  Color get warningLightValue => _hexToColor(warningLight);
  Color get warningDarkValue => _hexToColor(warningDark);
  Color get infoColorValue => _hexToColor(infoColor);
  Color get infoLightValue => _hexToColor(infoLight);
  Color get infoDarkValue => _hexToColor(infoDark);
  
  // Background and Surface Colors
  Color get backgroundColorValue => _hexToColor(backgroundColor);
  Color get surfaceColorValue => _hexToColor(surfaceColor);
  Color get cardColorValue => _hexToColor(cardColor);
  Color get dividerColorValue => _hexToColor(dividerColor);
  
  // Text Colors
  Color get textPrimaryColorValue => _hexToColor(textPrimaryColor);
  Color get textSecondaryColorValue => _hexToColor(textSecondaryColor);
  Color get textDisabledColorValue => _hexToColor(textDisabledColor);
  Color get textOnPrimaryValue => _hexToColor(textOnPrimary);
  Color get textOnSurfaceValue => _hexToColor(textOnSurface);
  
  // Border Colors
  Color get borderColorValue => _hexToColor(borderColor);
  
  // Shadow Colors
  Color get shadowColorValue => _hexToColor(shadowColor);
  Color get elevationShadowValue => _hexToColor(elevationShadow);
}