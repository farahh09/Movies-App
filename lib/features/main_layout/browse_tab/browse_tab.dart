import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movies/core/widgets/custom_grid_view.dart';
import 'package:movies/di.dart';
import 'package:movies/features/main_layout/browse_tab/presentation/bloc/browse_bloc.dart';
import 'package:movies/features/main_layout/browse_tab/presentation/bloc/browse_event.dart';
import 'package:movies/features/main_layout/browse_tab/presentation/bloc/browse_states.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';
import 'package:movies/utils/app_colors.dart';

class BrowseTab extends StatefulWidget {
  final List<dynamic>? genres;
  final int? genreIndex;

  const BrowseTab({super.key, this.genres, this.genreIndex});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  int selectedIndex = 0;

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
        create: (context) => getIt<BrowseBloc>()..add(BrowseMoviesEvent(widget.genres?[widget.genreIndex?? 0])),
        child: BlocConsumer<BrowseBloc, BrowseStates>(
          listener: (context, state) {
            if (state.browseMoviesStatus == RequestStatus.loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }

          },
          builder: (context, state) {
            final movies = state.movieResponse?.data?.movies;
            return Scaffold(
              backgroundColor: AppColors.blackColor,
              body: SafeArea(
                child: Column(
                  spacing: 25,
                  children: [
                    Row(
                      children: [
                        if (widget.genreIndex != null)
                          IconButton(
                            onPressed: () { Navigator.pop(context); },
                            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          ),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ListView.separated(
                              padding: EdgeInsets.only(left: 16),
                              itemCount: (widget.genreIndex != null) ? 1 : widget.genres?.length ?? 0,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                    context.read<BrowseBloc>().add(BrowseMoviesEvent('${widget.genres?[index] ?? ''}'));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12,),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: selectedIndex == index
                                          ? AppColors.yellowColor
                                          : AppColors.blackColor,
                                      border: BoxBorder.all(
                                        color: AppColors.yellowColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          (widget.genreIndex != null) ? '${widget.genres?[widget.genreIndex??0]}' : '${widget.genres?[index]}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                            color: selectedIndex == index
                                                ? AppColors.blackColor
                                                : AppColors.yellowColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomGridView(movies: movies),
                        )
                    )
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

//
