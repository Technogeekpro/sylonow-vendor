import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'theater_theme.freezed.dart';
part 'theater_theme.g.dart';

@freezed
class TheaterTheme with _$TheaterTheme {
  const factory TheaterTheme({
    required String id,
    required String name,
    required String description,
    required String primaryColor,
    required String secondaryColor,
    required String backgroundImageUrl,
    required String previewImageUrl,
    @Default(true) bool isActive,
  }) = _TheaterTheme;

  factory TheaterTheme.fromJson(Map<String, dynamic> json) =>
      _$TheaterThemeFromJson(json);
}

// Predefined theater themes
class TheaterThemes {
  static const List<TheaterTheme> predefinedThemes = [
    TheaterTheme(
      id: 'classic_red',
      name: 'Classic Red',
      description: 'Traditional theater experience with rich red curtains',
      primaryColor: '#DC143C',
      secondaryColor: '#8B0000',
      backgroundImageUrl: 'https://images.unsplash.com/photo-1489599396379-2cdca62f6c2a?w=800',
      previewImageUrl: 'https://images.unsplash.com/photo-1489599396379-2cdca62f6c2a?w=400',
    ),
    TheaterTheme(
      id: 'modern_blue',
      name: 'Modern Blue',
      description: 'Contemporary design with cool blue tones',
      primaryColor: '#1E88E5',
      secondaryColor: '#0D47A1',
      backgroundImageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      previewImageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    ),
    TheaterTheme(
      id: 'luxury_gold',
      name: 'Luxury Gold',
      description: 'Premium experience with golden elegance',
      primaryColor: '#FFD700',
      secondaryColor: '#B8860B',
      backgroundImageUrl: 'https://images.unsplash.com/photo-1516307365426-bea591f05011?w=800',
      previewImageUrl: 'https://images.unsplash.com/photo-1516307365426-bea591f05011?w=400',
    ),
    TheaterTheme(
      id: 'romantic_pink',
      name: 'Romantic Pink',
      description: 'Perfect for intimate celebrations and romantic events',
      primaryColor: '#FF69B4',
      secondaryColor: '#C71585',
      backgroundImageUrl: 'https://images.unsplash.com/photo-1511376777868-611b54f68947?w=800',
      previewImageUrl: 'https://images.unsplash.com/photo-1511376777868-611b54f68947?w=400',
    ),
    TheaterTheme(
      id: 'nature_green',
      name: 'Nature Green',
      description: 'Eco-friendly theme with natural green ambiance',
      primaryColor: '#32CD32',
      secondaryColor: '#228B22',
      backgroundImageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      previewImageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    ),
    TheaterTheme(
      id: 'dark_purple',
      name: 'Dark Purple',
      description: 'Mysterious and sophisticated purple theme',
      primaryColor: '#8A2BE2',
      secondaryColor: '#4B0082',
      backgroundImageUrl: 'https://images.unsplash.com/photo-1514306191717-452ec28c7814?w=800',
      previewImageUrl: 'https://images.unsplash.com/photo-1514306191717-452ec28c7814?w=400',
    ),
  ];

  // Helper method to get theme by ID
  static TheaterTheme? getThemeById(String id) {
    try {
      return predefinedThemes.firstWhere((theme) => theme.id == id);
    } catch (e) {
      return null;
    }
  }

  // Helper method to convert hex color to Color
  static Color hexToColor(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  }
}