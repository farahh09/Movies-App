import 'package:cloud_firestore/cloud_firestore.dart';
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
                      _buildGrid('watch_list'),
                      _buildGrid('watch_history'),
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
    final uid = _authService.currentUser?.uid;
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
        _buildLiveCount(uid, 'watch_list', 'Wish List'),
        _buildLiveCount(uid, 'watch_history', 'History'),
      ],
    );
  }

  Widget _buildLiveCount(String? uid, String collection, String label) {
    if (uid == null) return _buildStat('0', label);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).collection(collection).snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;
        return _buildStat(count.toString(), label);
      },
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

  Widget _buildGrid(String collection) {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(collection)
          .orderBy('addedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Image.asset("assets/images/empty_result.png", width: 120),
          );
        }

        final movies = snapshot.data!.docs;
        return GridView.builder(
          padding: const EdgeInsets.all(15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final data = movies[index].data() as Map<String, dynamic>;
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data['cover'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: ColorManager.darkGrey,
                  child: Icon(Icons.movie, color: ColorManager.white.withOpacity(0.2)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}