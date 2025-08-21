import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../models/theater_theme.dart';
import '../controllers/themed_add_theater_controller.dart';

class TheaterThemeSelector extends ConsumerWidget {
  const TheaterThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themedAddTheaterControllerProvider);
    final selectedTheme = controller.selectedTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Theme Preview (if any)
        if (selectedTheme != null) ...[
          _buildSelectedThemePreview(selectedTheme),
          const SizedBox(height: 24),
        ],
        
        // Theme Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: TheaterThemes.predefinedThemes.length,
          itemBuilder: (context, index) {
            final theme = TheaterThemes.predefinedThemes[index];
            final isSelected = selectedTheme?.id == theme.id;
            
            return _buildThemeCard(
              theme,
              isSelected,
              () => ref.read(themedAddTheaterControllerProvider.notifier).selectTheme(theme),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSelectedThemePreview(TheaterTheme theme) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TheaterThemes.hexToColor(theme.primaryColor),
            TheaterThemes.hexToColor(theme.secondaryColor),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: TheaterThemes.hexToColor(theme.primaryColor).withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(theme.backgroundImageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      TheaterThemes.hexToColor(theme.primaryColor).withOpacity(0.7),
                      BlendMode.overlay,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Selected Theme',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  theme.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  theme.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(TheaterTheme theme, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
              ? TheaterThemes.hexToColor(theme.primaryColor)
              : AppTheme.borderColor,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected 
            ? [
                BoxShadow(
                  color: TheaterThemes.hexToColor(theme.primaryColor).withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : [AppTheme.cardShadow],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Preview Image
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            TheaterThemes.hexToColor(theme.primaryColor),
                            TheaterThemes.hexToColor(theme.secondaryColor),
                          ],
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: theme.previewImageUrl,
                        fit: BoxFit.cover,
                      
                        placeholder: (context, url) => Container(
                          color: TheaterThemes.hexToColor(theme.primaryColor).withOpacity(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: TheaterThemes.hexToColor(theme.primaryColor),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    
                    // Selection Indicator
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: TheaterThemes.hexToColor(theme.primaryColor),
                            size: 18,
                          ),
                        ),
                      ),
                    
                    // Color Palette Indicator
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: TheaterThemes.hexToColor(theme.primaryColor),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: TheaterThemes.hexToColor(theme.secondaryColor),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Theme Info
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        theme.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected 
                            ? TheaterThemes.hexToColor(theme.primaryColor)
                            : AppTheme.textPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        theme.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}