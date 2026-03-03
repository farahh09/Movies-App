import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/resources/color_manager.dart';
import 'package:movies/di.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/home_tab/presentation/widgets/movie_card.dart';
import 'package:movies/features/main_layout/search_tab/presentation/bloc/search_bloc.dart';
import 'package:movies/features/main_layout/search_tab/presentation/bloc/search_event.dart';
import 'package:movies/features/main_layout/search_tab/presentation/bloc/search_states.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SearchBloc>()..add(SearchMoviesEvent(searchController.text)),
      child: BlocConsumer<SearchBloc, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final movies = state.movieResponse?.data?.movies;
          return Scaffold(
            backgroundColor: ColorManager.black,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: ColorManager.white),
                      controller: searchController,
                      onChanged: (value) {
                        context.read<SearchBloc>().add(SearchMoviesEvent(value));
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: ColorManager.white),
                        prefixIcon: ImageIcon(
                          AssetImage('assets/icons/search_ic.png'),
                          color: ColorManager.white,
                        ),
                        fillColor: ColorManager.darkGrey,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: ColorManager.yellow),
                        ),
                      ),
                    ),
                    SizedBox(height: 13.h),
                    searchController.text.isEmpty
                        ? Expanded(child: Center(child: Image.asset('assets/images/empty_result.png',),))
                        : Expanded(
                            child: GridView.builder(
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
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}