import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:bottom_nav_bar/bottom_nav_bar.dart';
import 'package:dasboard_admin/screens/dashboard/screen_dashboard.dart';
import 'package:dasboard_admin/screens/manager_user/screen_user_overview.dart';
import 'package:dasboard_admin/screens/users/screen_user_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreenContainPanigator extends StatefulWidget {
  const MainScreenContainPanigator({super.key});

  @override
  State<MainScreenContainPanigator> createState() =>
      _MainScreenContainPanigatorState();
}

class _MainScreenContainPanigatorState
    extends State<MainScreenContainPanigator> {
  //* Define Vaviable
  int _currentIndex = 0;

  //* Init state
  @override
  void initState() {
    super.initState();
  }

  //* Item
  static const List<TabItem> items = [
    TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    TabItem(
      icon: Icons.add_chart_outlined,
      title: 'Overview',
    ),
    TabItem(
      icon: Icons.person,
      title: 'User',
    ),
  ];

  //* Define Page
  Widget _body() => SizedBox.expand(
        child: IndexedStack(
          index: _currentIndex,
          children: const <Widget>[
            ScreenDashboard(),
            ScreenUsersSetting(),
            UserOverviewScreen(),
          ],
        ),
      );

  //* Define Panigator
  Widget _bottomNavBar() => Container(
        margin: const EdgeInsets.only(bottom: 15, right: 15, left: 15),
        child: BottomBarFloating(
          items: items,
          borderRadius: BorderRadius.circular(50),
          backgroundColor: Colors.white,
          color: Colors.black,
          colorSelected: Colors.red,
          indexSelected: _currentIndex,
          onTap: (int index) => setState(() {
            _currentIndex = index;
          }),
        ),
      );
  //* Main Build
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _body(),
      bottomNavigationBar: _bottomNavBar(),
    ));
  }
}
