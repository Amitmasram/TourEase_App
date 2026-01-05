import 'package:TourEase/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;

  const OnboardingPage(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image, height: 300, width: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.onBoardingTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              subTitle,
              style: AppTextStyles.onBoardingSubTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
