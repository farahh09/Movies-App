import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/routes_manager/routes.dart';
import 'package:movies/core/widgets/movie_card.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

class CustomGridView extends StatelessWidget {
  final List<Movies>? movies;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const CustomGridView({
    super.key,
    required this.movies,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: movies?.length ?? 0,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
        childAspectRatio: 191 / 279,
      ),
      itemBuilder: (BuildContext context, int index) {
        final movie = movies?[index] ?? Movies();
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.movieDetailsRoute,
              arguments: movie.id,
            );
          },
          child: MovieCard(movie: movie, width: 190.w, height: 279.h),
        );
      },
    );
  }
}
