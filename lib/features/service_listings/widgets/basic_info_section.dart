import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_service_controller.dart';

class BasicInfoSection extends StatefulWidget {
  final AddServiceController controller;

  const BasicInfoSection({
    super.key,
    required this.controller,
  });

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection> {
  @override
  void initState() {
    super.initState();
    // Debug: Ensure form key is properly set
    print(
        '🔧 BasicInfoSection: Form key initialized - ${widget.controller.formKey}');
  }

  @override
  Widget build(BuildContext context) {
    // Debug: Check form key state during build
    print(
        '🔧 BasicInfoSection: Building with form key - ${widget.controller.formKey}');
    print(
        '🔧 BasicInfoSection: Form state exists - ${widget.controller.formKey.currentState != null}');

    return Form(
      key: widget.controller.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            _buildSectionTitle('Service Title'),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.controller.titleController,
              decoration: _buildInputDecoration(
                'e.g., "Birthday Decor for Kids"',
                Icons.title_rounded,
              ),
              validator: widget.controller.validateTitle,
              maxLength: 100,
            ),

            const SizedBox(height: 24),

            // Category Selection
            _buildSectionTitle('Category'),
            const SizedBox(height: 8),
            _buildCategorySelection(),

            const SizedBox(height: 24),

            // Service Environment
            _buildSectionTitle('Service Environment'),
            const SizedBox(height: 8),
            _buildServiceEnvironmentSelection(),

            const SizedBox(height: 24),

            // Theme Tags
            _buildSectionTitle('Theme Tags'),
            const SizedBox(height: 8),
            _buildThemeTagsSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: AppTheme.surfaceColor,
    );
  }

  Widget _buildCategorySelection() {
    return DropdownButtonFormField<String>(
      value: widget.controller.selectedCategory,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: HeroIcon(HeroIcons.cog, color: AppTheme.primaryColor),
      ),
      hint: const Text('Select a category'),
      items: widget.controller.categories.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          widget.controller.selectedCategory = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _buildServiceEnvironmentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Where can your service be provided?',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: widget.controller.selectedServiceEnvironments.isNotEmpty
              ? widget.controller.selectedServiceEnvironments.first
              : null,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            prefixIcon:
                Icon(Icons.location_on_rounded, color: AppTheme.primaryColor),
          ),
          hint: const Text('Select service environment'),
          items: const [
            DropdownMenuItem<String>(
              value: 'indoor',
              child: Row(
                children: [
                  HeroIcon(HeroIcons.home,
                      size: 18, color: AppTheme.primaryColor),
                  SizedBox(width: 8),
                  Text('Indoor'),
                ],
              ),
            ),
            DropdownMenuItem<String>(
              value: 'outdoor',
              child: Row(
                children: [
                  HeroIcon(HeroIcons.buildingOffice,
                      size: 18, color: AppTheme.primaryColor),
                  SizedBox(width: 8),
                  Text('Outdoor'),
                ],
              ),
            ),
            DropdownMenuItem<String>(
              value: 'both',
              child: Row(
                children: [
                  Icon(Icons.home_work_rounded,
                      size: 18, color: AppTheme.primaryColor),
                  SizedBox(width: 8),
                  Text('Indoor & Outdoor'),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              widget.controller.selectedServiceEnvironments.clear();
              if (value != null) {
                if (value == 'both') {
                  widget.controller.selectedServiceEnvironments
                      .addAll(['indoor', 'outdoor']);
                } else {
                  widget.controller.selectedServiceEnvironments.add(value);
                }
              }
            });
          },
          validator: (value) {
            if (widget.controller.selectedServiceEnvironments.isEmpty) {
              return 'Please select a service environment';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          widget.controller.selectedServiceEnvironments.isEmpty
              ? 'No environment selected'
              : widget.controller.selectedServiceEnvironments.length == 2
                  ? 'Indoor & Outdoor service available'
                  : '${widget.controller.selectedServiceEnvironments.first.toUpperCase()} service available',
          style: TextStyle(
            fontSize: 12,
            color: widget.controller.selectedServiceEnvironments.isEmpty
                ? AppTheme.errorColor
                : AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeTagsSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select tags that best describe your service theme:',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.controller.themeTags.map((tag) {
            final isSelected =
                widget.controller.selectedThemeTags.contains(tag);
            return GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller.toggleThemeTag(tag);
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.borderColor,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        isSelected ? Colors.white : AppTheme.textPrimaryColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.controller.selectedThemeTags.length} tags selected',
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
