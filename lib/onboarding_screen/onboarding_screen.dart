import 'package:flutter/material.dart';
import 'package:movies/core/routes_manager/routes.dart';
import 'package:movies/utils/app_colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _pages = [
    {
      "title": "Find Your Next\nFavorite Movie Here",
      "body": "Get access to a huge library of movies\nto suit all tastes. You will surely like it.",
      "image": "assets/images/onboarding_screen_1.png",
    },
    {
      "title": "Discover Movies",
      "body": "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
      "image": "assets/images/onboarding_screen_2.png",
    },
    {
      "title": "Explore All Genres",
      "body": "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
      "image": "assets/images/onboarding_screen_3.png",
    },
    {
      "title": "Create Watchlists",
      "body": "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
      "image": "assets/images/onboarding_screen_4.png",
    },
    {
      "title": "Rate, Review, and Learn",
      "body": "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
      "image": "assets/images/onboarding_screen_5.png",
    },
    {
      "title": "Start Watching Now",
      "body": "",
      "image": "assets/images/onboarding_screen_6.png",
    },
  ];

  void _onNextPage(int index) {
    if (index < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(
        Routes.loginRoute,
      );
    }
  }

  void _onBackPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          final page = _pages[index];
          final bool hasBody = page["body"] != null && page["body"]!.isNotEmpty;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(page["image"]!, fit: BoxFit.cover),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.transparent : AppColors.blackColor,
                    borderRadius: index == 0
                        ? BorderRadius.zero
                        : const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        page["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: size.width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasBody) ...[
                        const SizedBox(height: 16),
                        Text(
                          page["body"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(0.7),
                            fontSize: size.width * 0.045,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      if (index == 0)
                        _buildExploreNowButton(() => _onNextPage(index), size)
                      else
                        _buildStandardButtons(index, size),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExploreNowButton(VoidCallback onTap, Size size) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
        decoration: BoxDecoration(
          color: AppColors.yellowColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          "Explore Now",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildStandardButtons(int index, Size size) {
    return Column(
      children: [
        _buildElevatedButton(
          text: index == _pages.length - 1 ? "Finish" : "Next",
          onPressed: () => _onNextPage(index),
          size: size,
          isBack: false,
        ),
        const SizedBox(height: 16),
        _buildElevatedButton(
          text: "Back",
          onPressed: _onBackPage,
          size: size,
          isBack: true,
        ),
      ],
    );
  }

  Widget _buildElevatedButton({
    required String text,
    required VoidCallback onPressed,
    required Size size,
    required bool isBack,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isBack ? Colors.transparent : AppColors.yellowColor,
          foregroundColor: isBack ? AppColors.yellowColor : AppColors.blackColor,
          side: isBack
              ? const BorderSide(color: AppColors.yellowColor, width: 2)
              : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
          elevation: isBack ? 0 : 4,
        ),
        onPressed: onPressed,
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}