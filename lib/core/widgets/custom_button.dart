// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:TourEase/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double width;

  GradientButton(
      {super.key, this.onPressed, required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: GradientColors.gradient,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            // ignore: prefer_const_constructors
            style: AppTextStyles.buttonText,
          ),
        ),
      ),
    );
  }
}
