import 'package:TourEase/core/constants/text_strings.dart';
import 'package:TourEase/core/utils/image_strings.dart';
import 'package:TourEase/core/utils/responsive.dart';
import 'package:TourEase/core/widgets/custom_button.dart';
import 'package:TourEase/views/auth/home_auth_screen.dart';

import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import 'widgets/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              OnboardingPage(
                image: ImageStrings.onboardingImage1,
                title: AppStrings.onBoardingTitle1,
                subTitle: AppStrings.onBoardingSubTitle1,
              ),
              OnboardingPage(
                image: ImageStrings.onboardingImage2,
                title: AppStrings.onBoardingTitle2,
                subTitle: AppStrings.onBoardingSubTitle2,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: buildFooter(),
          ),
        ],
      ),
    );
  }

  Widget buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(2, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? null : Colors.grey,
                gradient: _currentIndex == index
                    // ignore: prefer_const_constructors
                    ? GradientColors.gradient
                    : null,
              ),
            );
          }),
        ),
        if (_currentIndex < 1)
          GradientButton(
            width: Responsive.screenWidth(context) * 0.35,
            text: 'Next',
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
        if (_currentIndex == 1)
          GradientButton(
            width: Responsive.screenWidth(context) * 0.4,
            text: 'Get Started',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeAuthScreen()));
            },
          ),
      ],
    );
  }
}
