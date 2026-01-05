import 'package:TourEase/core/constants/colors.dart';
import 'package:TourEase/core/constants/text_strings.dart';
import 'package:TourEase/core/utils/responsive.dart';
import 'package:TourEase/core/utils/text_styles.dart';
import 'package:TourEase/views/home/home/notification_screen.dart';
import 'package:TourEase/views/home/home/tabs_screens/all_screen.dart';
import 'package:TourEase/views/home/home/tabs_screens/lakes_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/helpers/helper.dart';
import 'tabs_screens/hills_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // ignore: unused_field
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _showEditProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: Responsive.screenHeight(context) * 1 / 2.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Responsive.screenWidth(context) * 0.8,
                child: Divider(
                  thickness: 2,
                  color: THelperFunctions.isDarkMode(context)
                      ? AppColors.white
                      : AppColors.grey,
                ),
              ),
              Text('Edit Profile Picture', style: AppTextStyles.bodyText2),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  // Implement functionality to take a photo
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  // Implement functionality to choose from gallery
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? AppColors.dark : AppColors.light,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: dark ? AppColors.dark : AppColors.light2,
              title: Text(
                AppStrings.appName,
                style: AppTextStyles.bodyText3,
              ),
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Row(
                    children: [
                      Container(
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              // Remove the key parameter since it's not necessary
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationScreen()),
                              );
                            },
                            child: FaIcon(
                              FontAwesomeIcons.bell,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Responsive.screenWidth(context) * 0.04,
                      ),
                      // GestureDetector(
                      //   onTap: _showEditProfileBottomSheet,
                      //   child: Container(
                      //     height: 32,
                      //     width: 32,
                      //     padding: const EdgeInsets.all(1.5),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(16.0),
                      //       boxShadow: [BoxShadow(color: Colors.grey.shade300)],
                      //       gradient: GradientColors.gradient,
                      //     ),
                      //     child: const ClipOval(
                      //       child: Image(
                      //         fit: BoxFit.fill,
                      //         image: NetworkImage(
                      //             'https://media.licdn.com/dms/image/v2/D5603AQFTcBY13wkKpQ/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1711761057818?e=1733961600&v=beta&t=CGYJJY3E42DyCTO63303t_PXdKuM-xlTGImtj3sOE4k'),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: dark ? AppColors.white : AppColors.black,
                labelStyle: AppTextStyles.headline1.copyWith(fontSize: 14),
                unselectedLabelStyle:
                    AppTextStyles.bodyText.copyWith(fontSize: 14),
                isScrollable: true,
                tabs: const [
                  Tab(
                    text: AppStrings.all,
                  ),
                  Tab(
                    text: AppStrings.hills,
                  ),
                  Tab(
                    text: AppStrings.mountains,
                  ),
                  Tab(
                    text: AppStrings.lakes,
                  ),
                  Tab(
                    text: AppStrings.cities,
                  ),
                  Tab(
                    text: AppStrings.trackTab,
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [

            AllScreen(),
            HillsScreen(),
            Center(child: Text(AppStrings.mountains)),
            LakesScreen(),
            Center(child: Text(AppStrings.cities)),
            Center(child: Text(AppStrings.trackTab)),
          ],
        ),
      ),
    );
  }
}
