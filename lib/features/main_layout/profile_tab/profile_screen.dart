import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/profile_view_model.dart';
import 'package:movies/core/resources/color_manager.dart';
import 'package:movies/services/AuthService.dart';
import 'package:movies/core/routes_manager/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorManager.black,
        body: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator(color: ColorManager.yellow));
            }

            final user = viewModel.userModel;
            if (user == null) return const SizedBox();

            return Column(
              children: [
                const SizedBox(height: 60),
                _buildHeader(user),
                const SizedBox(height: 25),
                _buildActionButtons(context),
                const SizedBox(height: 25),
                TabBar(
                  indicatorColor: ColorManager.yellow,
                  labelColor: ColorManager.yellow,
                  unselectedLabelColor: ColorManager.white,
                  tabs: [
                    Tab(icon: Icon(Icons.list, color: ColorManager.yellow), text: "Watch List"),
                    Tab(icon: Icon(Icons.history, color: ColorManager.yellow), text: "History"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildGrid(user.watchListCount),
                      _buildGrid(user.historyCount),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            CircleAvatar(radius: 45, backgroundImage: AssetImage(user.imagePath)),
            const SizedBox(height: 12),
            Text(user.name, style: TextStyle(color: ColorManager.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        _buildStat(user.watchListCount.toString(), "Wish List"),
        _buildStat(user.historyCount.toString(), "History"),
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: ColorManager.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: ColorManager.white.withOpacity(0.7), fontSize: 14)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.yellow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.updateProfileRoute);
              },
              child: Text("Edit Profile", style: TextStyle(color: ColorManager.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                await _authService.signOut();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginRoute,
                      (route) => false,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Exit", style: TextStyle(color: ColorManager.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 5),
                  Icon(Icons.exit_to_app, color: ColorManager.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(int count) {
    if (count == 0) {
      return Center(child: Image.asset("assets/images/empty_result.png", width: 120));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: count,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: ColorManager.darkGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.movie, color: ColorManager.white.withOpacity(0.2)),
      ),
    );
  }
}