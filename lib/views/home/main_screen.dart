
import 'package:TourEase/views/home/ai_Chat/ai_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/colors.dart';

import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    AiChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? const GradientIcon(
                      icon: Icons.home,
                      size: 30.0,
                      gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary]))
                  : const Icon(
                      Icons.home,
                      size: 28.0,
                    ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? const GradientIcon(
                      icon: FontAwesomeIcons.magnifyingGlass,
                      size: 24.0,
                      gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary]))
                  : const Icon(FontAwesomeIcons.magnifyingGlass, size: 22.0),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? const GradientImageIcon(
                      image: AssetImage('assets/images/spark.png'),
                      size: 32.0,
                      gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary]))
                  : const SizedBox(
                      height: 30,
                      width: 30,
                      child: Image(
                        image: AssetImage('assets/images/spark.png'),
                        color: Colors.grey,
                      ),
                    ),
              label: 'Ai Chat',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? const GradientIcon(
                      icon: FontAwesomeIcons.user,
                      size: 23.0,
                      gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary]))
                  : const Icon(
                      FontAwesomeIcons.user,
                      size: 22.0,
                    ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final double size;

  const GradientIcon({
    super.key,
    required this.icon,
    required this.gradient,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

class GradientImageIcon extends StatelessWidget {
  final ImageProvider image;
  final LinearGradient gradient;
  final double size;

  const GradientImageIcon({
    super.key,
    required this.image,
    required this.gradient,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Image(
        image: image,
        width: size,
        height: size,
        color: Colors.white,
      ),
    );
  }
}
