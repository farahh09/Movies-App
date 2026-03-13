import 'package:flutter/material.dart';
import 'package:movies/core/routes_manager/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.updateProfileRoute);
              },
              child: const Text("Go to Profile Page"),
            ),
          ],
        ),
      ),
    );
  }
}