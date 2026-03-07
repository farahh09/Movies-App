import 'package:flutter/material.dart';
import 'package:movies/core/resources/color_manager.dart';
import 'package:movies/core/routes_manager/routes.dart';
import 'package:movies/features/main_layout/browse_tab/browse_tab.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

class MoviesGenre extends StatelessWidget {
  final List<Movies>? movies;
  final List<dynamic>? genres;
  final int index;
  final String genre;

  const MoviesGenre({
    super.key,
    required this.movies,
    required this.index, required this.genre, this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 5),
              child: Text(genre, style: TextStyle(color: ColorManager.white, fontSize: 20, fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 19),
              child: Row(
                spacing: 2,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.browseRoute, arguments: {
                          "genreIndex": index,
                          "genres": genres,
                        },);
                      },
                      child: Text('See More', style: TextStyle(color: ColorManager.yellow),)),
                  Icon(Icons.arrow_forward, color: ColorManager.yellow,size: 15,),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 12,),
        SizedBox(
          height: 220,
          child: ListView.builder(
            itemCount: movies?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final movie = movies?[index] ?? Movies();
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(
                    context,
                    Routes.movieDetailsRoute,
                    arguments: movie.id,
                  );
                },
                child: Container(
                  width: 140,
                  height: 220,
                  margin: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadiusGeometry.circular(20,),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadiusGeometry.circular(20,),
                        child: Stack(
                          children: [
                            Image.network(
                              movie.mediumCoverImage ?? '',
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 11, left: 9,),
                              child: Container(
                                width: 60,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusGeometry.circular(10,),
                                  color: ColorManager.darkGrey.withOpacity(0.7,),
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
                                      color: ColorManager.yellow,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

      ],
    );
  }
}
