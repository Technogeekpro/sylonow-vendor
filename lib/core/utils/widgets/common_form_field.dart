import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CommonFormField extends StatelessWidget {
  final String name;
  final String label;
  final String hintText;
  final Color focusColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isRequired;
  final String? Function(dynamic)? validator;
  final String? initialValue;
  final String? prefixText;

  const CommonFormField({
    super.key,
    required this.name,
    required this.label,
    required this.hintText,
    required this.focusColor,
    this.keyboardType,
    this.inputFormatters,
    this.isRequired = false,
    this.validator,
    this.initialValue,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: name,
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: focusColor, width: 2),
            ),
          ),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
        ),
      ],
    );
  }
} 