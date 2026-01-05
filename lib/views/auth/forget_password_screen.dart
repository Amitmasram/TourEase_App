import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/text_strings.dart';
import '../../core/helpers/helper.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/text_styles.dart';
import 'package:TourEase/core/widgets/custom_button.dart';
import 'package:TourEase/core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnackbar('Please enter your email.');
      return;
    }
    try {
      await auth.sendPasswordResetEmail(email: email);
      _showSnackbar("Password reset link sent! Check your email.");
    } catch (e) {
      _showSnackbar("An error occurred. Please try again.");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: dark ? AppColors.dark : AppColors.light,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: dark ? AppColors.dark : AppColors.light,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: dark ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: Responsive.screenHeight(context) * 0.9,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: Responsive.screenHeight(context) * 0.05),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: <Widget>[
                    Text(
                      AppStrings.resendEmail,
                      style: AppTextStyles.headline1,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.loginSubTitle,
                      style: AppTextStyles.onBoardingSubTitle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: CustomTextField(
                    label: "Email",
                    controller: _emailController,
                    obscureText: false,
                    hintText: 'Enter your registered email',
                  ),
                ),
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.05),
              SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GradientButton(
                    text: AppStrings.confirmEmail,
                    width: Responsive.screenWidth(context) * 0.8,
                    onPressed: _resetPassword,
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
