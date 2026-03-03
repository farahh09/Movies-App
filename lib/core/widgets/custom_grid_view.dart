import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/widgets/movie_card.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

class CustomGridView extends StatelessWidget {
  final List<Movies>? movies;

  const CustomGridView({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: movies?.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
        childAspectRatio: 191 / 279,
      ),
      itemBuilder: (BuildContext context, int index) {
        final movie = movies?[index] ?? Movies();
        return MovieCard(
          movie: movie,
          width: 190.w,
          height: 279.h,
        );
      },
    );
  }
}
