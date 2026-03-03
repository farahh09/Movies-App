import 'package:flutter/material.dart';
import 'package:movies/core/resources/color_manager.dart';
import 'package:movies/features/main_layout/browse_tab/browse_tab.dart';
import 'package:movies/features/main_layout/home_tab/home_tab.dart';
import 'package:movies/features/main_layout/profile_tab/profile_tab.dart';
import 'package:movies/features/main_layout/search_tab/search_tab.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  List<Widget> tabs = [HomeTab(), SearchTab(), BrowseTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: tabs[currentIndex],
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(16),
            child: SizedBox(
              height: 60,
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                backgroundColor: ColorManager.darkGrey,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: ColorManager.yellow,
                unselectedItemColor: ColorManager.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage('assets/icons/home_ic.png')),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage('assets/icons/search_ic.png')),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage('assets/icons/explore_ic.png')),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage('assets/icons/profile_ic.png')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
