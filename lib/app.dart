import 'package:TourEase/core/app_theme.dart';
import 'package:TourEase/viewmodels/login_view_model.dart';
import 'package:TourEase/viewmodels/signup_view_model.dart';
import 'package:TourEase/views/home/main_screen.dart';
import 'package:TourEase/views/onboarding/onboarding_screen.dart';
import 'package:TourEase/viewmodels/user_prefrences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TourEase extends StatefulWidget {
  // ignore: use_super_parameters
  const TourEase({Key? key}) : super(key: key);

  @override
  State<TourEase> createState() => _TourEaseState();
}

class _TourEaseState extends State<TourEase> {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = await UserPreferences.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
      ],
      child: MaterialApp(
        title: 'TourEase',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routes: const {},
        home: _isLoading
            ? _buildLoading()
            : (_isLoggedIn ? const MainScreen() : const OnboardingScreen()),
      ),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
