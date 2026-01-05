import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool obscureText;
  final int? maxLines;
  final VoidCallback? onIconPressed;
  final Function(String)? onChanged; // Added onChanged callback
  final String? errorText; // Added errorText parameter

  const CustomTextField({
    super.key,
    this.icon,
    required this.hintText,
    required this.controller,
    required this.label,
    this.maxLines,
    this.obscureText = false,
    this.onIconPressed,
    this.onChanged, // Initialize in constructor
    this.errorText, // Initialize in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.bodyText),
        const SizedBox(height: 5),
        TextFormField(
          maxLines: maxLines ?? 1,
          controller: controller,
          obscureText: obscureText,
          cursorColor: AppColors.primary,
          onChanged: onChanged, // Use the onChanged callback
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyText,
            suffixIcon: icon == null
                ? null
                : IconButton(
                    icon: Icon(icon),
                    onPressed: onIconPressed,
                  ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorText: errorText, // Display error message
          ),
        ),
      ],
    );
  }
}
