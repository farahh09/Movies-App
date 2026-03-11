import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/utils/app_colors.dart';

class MovieCard extends StatelessWidget {
  final Movies movie;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r,),
            child: Image.network(
              movie.mediumCoverImage ?? '',
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 11, left: 9,),
            child: Container(
              width: 60,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.greyColor.withOpacity(0.7,),
              ),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${movie.rating}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: AppColors.yellowColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}