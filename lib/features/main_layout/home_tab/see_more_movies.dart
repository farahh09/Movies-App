import 'package:flutter/material.dart';
import 'package:movies/core/resources/color_manager.dart';
import 'package:movies/core/widgets/custom_grid_view.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

class SeeMoreMovies extends StatelessWidget {
  final List<Movies> movies;
  const SeeMoreMovies({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomGridView(movies: movies),
          )
      ),
    );
  }
}
