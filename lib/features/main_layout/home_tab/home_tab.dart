import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/widgets/movie_card.dart';
import 'package:movies/core/widgets/movies_genre.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_bloc.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';
import 'package:movies/utils/app_colors.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final movies = state.movieResponse?.data?.movies;
        final genres = movies?.expand((movie) => movie.genres ?? []).toSet().toList();

        return Scaffold(
          backgroundColor: AppColors.blackColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 625.h,
                  child: Stack(
                    children: [
                      Image.network(
                        state.movieResponse?.data?.movies?[currentIndex].largeCoverImage ?? '',
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image);
                        },
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.blackColor.withOpacity(0.8),
                              AppColors.blackColor.withOpacity(0.6),
                              AppColors.blackColor,
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 40.h),
                          Image.asset(
                            'assets/images/available_now.png',
                            height: 100,
                            width: 250,
                          ),
                          CarouselSlider(
                            items: state.movieResponse?.data?.movies?.map((movie,) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return MovieCard(
                                    movie: movie,
                                    width: 234.w,
                                    height: 351.h,
                                  );
                                  },
                              );
                            }).toList() ?? [],
                            options: CarouselOptions(
                              height: 340.h,
                              viewportFraction: 0.65,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.25,
                              // autoPlay: true,
                              // autoPlayInterval: Duration(seconds: 3),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                          Image.asset(
                            'assets/images/watch_now.png',
                            height: 140.h,
                            width: 350.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    itemCount: genres?.length ?? 0,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final genre = genres?[index] ?? '';
                      final genreMovies = movies?.where((movie) => movie.genres?.contains(genre) ?? false).toList();
                      return MoviesGenre(
                        movies: genreMovies,
                        index: index,
                        genre: genres?[index],
                        genres: genres,
                      );
                    }
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
