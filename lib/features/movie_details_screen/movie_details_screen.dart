import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movies/core/widgets/custom_grid_view.dart';
import 'package:movies/di.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';
import 'package:movies/features/movie_details_screen/presentation/bloc/movie_details_bloc.dart';
import 'package:movies/features/movie_details_screen/presentation/bloc/movie_details_event.dart';
import 'package:movies/features/movie_details_screen/presentation/bloc/movie_details_states.dart';
import 'package:movies/utils/app_colors.dart';

class MovieDetailsScreen extends StatelessWidget {
  final num movieID;

  const MovieDetailsScreen({super.key, required this.movieID});

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.blackColor.withOpacity(0.7),
      overlayWidgetBuilder: (progress) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
      child: BlocProvider(
        create: (context) => getIt<MovieDetailsBloc>()
          ..add(GetMovieDetailsEvent(movieID.toString()))
          ..add(GetMoviesSuggestionEvent(movieID.toString()))
        ,
        child: BlocConsumer<MovieDetailsBloc, MovieDetailsStates>(
          listener: (context, state) {
            if (state.getMovieDetailsStatus == RequestStatus.loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }
          },
          builder: (context, state) {
            final movie = state.movieDetailsResponse?.data?.movie;
            final suggestedMovies = state.moviesSuggestionResponse?.data?.movies;
            if (movie == null) return Scaffold(backgroundColor: AppColors.blackColor, body: SizedBox());

            return Scaffold(
              backgroundColor: AppColors.blackColor,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 670.h,
                      child: Stack(
                        children: [
                          Image.network(movie.largeCoverImage ?? ''),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.blackColor.withOpacity(0.2),
                                  AppColors.blackColor,
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/play_movie.png'),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  movie.title ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "${movie.year ?? 0}",
                                  style: TextStyle(
                                    color: Color(0xFFADADAD),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 22),
                            child: SafeArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: AppColors.whiteColor,
                                      size: 29,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.bookmark_rounded,
                                      color: AppColors.whiteColor,
                                      size: 29,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: 398.w,
                      height: 58.h,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Text(
                          'Watch',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 16,
                            children: [
                              movieChip(
                                'assets/icons/heart_ic.png',
                                '${movie.likeCount ?? 0}',
                              ),
                              movieChip(
                                'assets/icons/clock_ic.png',
                                '${movie.runtime ?? 0}',
                              ),
                              movieChip(
                                'assets/icons/star_ic.png',
                                '${movie.rating ?? ''}',
                              ),
                            ],
                          ),

                          Text('Screen Shots', style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w700, fontSize: 24),),
                          Column(
                            spacing: 13,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(16.h),
                                  child: Image.network(movie.largeScreenshotImage1??'')),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(16.h),
                                  child: Image.network(movie.largeScreenshotImage2??'')),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(16.h),
                                  child: Image.network(movie.largeScreenshotImage3??'')),
                            ],
                          ),

                          Text('Similar', style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w700, fontSize: 24),),
                          CustomGridView(movies: suggestedMovies, shrinkWrap: true, physics: NeverScrollableScrollPhysics(),),

                          Text('Summary', style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w700, fontSize: 24),),
                          Text('${movie.descriptionIntro}',style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w400, fontSize: 16),),

                          Text('Cast', style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w700, fontSize: 24),),
                          ListView.separated(
                              itemCount: movie.cast?.length ?? 0,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.r),
                                        color: AppColors.greyColor
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(11),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(10.r),
                                              child: (movie.cast?[index].urlSmallImage?.isNotEmpty == true)
                                                  ? Image.network(
                                                movie.cast![index].urlSmallImage!,
                                              )
                                                  : SizedBox(width: 60.w, height: 60.h, child: Icon(Icons.person, color: Colors.white,),),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Name : ${movie.cast?[index].name}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 20,
                                                      color: AppColors.whiteColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    'Character : ${movie.cast?[index].characterName}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 20,
                                                      color: AppColors.whiteColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                );
                              }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8.h,),
                          ),

                          Text('Genres', style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w700, fontSize: 24),),
                          GridView.builder(
                              itemCount: movie.genres?.length ?? 0,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 10,
                                childAspectRatio: 122 / 36,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                final genre = movie.genres?[index] ?? '';
                                return Container(
                                    width: 122.w,
                                    height: 36.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.r),
                                        color: AppColors.greyColor
                                    ),
                                    child: Center(
                                        child: Text(
                                          genre,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: AppColors.whiteColor,
                                          ),
                                        )
                                    )
                                );
                              }
                          ),
                          SizedBox(height: 20.h,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Container movieChip(String icPath, String title) {
  return Container(
    width: 122.w,
    height: 47.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      color: AppColors.greyColor,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 18,
      children: [
        Image.asset(icPath, width: 28.w,height: 28.h,),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppColors.whiteColor,
          ),
        ),
      ],
    ),
  );
}
