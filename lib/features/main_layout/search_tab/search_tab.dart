import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/resources/color_manager.dart';
import 'package:movies/core/widgets/custom_grid_view.dart';
import 'package:movies/di.dart';
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
                            child: CustomGridView(movies: movies)
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