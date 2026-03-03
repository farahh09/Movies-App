import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movies/core/resources/color_manager.dart';
import 'package:movies/core/widgets/custom_grid_view.dart';
import 'package:movies/di.dart';
import 'package:movies/features/main_layout/browse_tab/presentation/bloc/browse_bloc.dart';
import 'package:movies/features/main_layout/browse_tab/presentation/bloc/browse_event.dart';
import 'package:movies/features/main_layout/browse_tab/presentation/bloc/browse_states.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';

class BrowseTab extends StatefulWidget {
  final List<dynamic>? genres;
  const BrowseTab({super.key, required this.genres});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: ColorManager.black.withOpacity(0.7),
      overlayWidgetBuilder: (progress) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
      child: BlocProvider(
        create: (context) => getIt<BrowseBloc>()..add(BrowseMoviesEvent(widget.genres?[0])),
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
              backgroundColor: ColorManager.black,
              body: SafeArea(
                child: Column(
                  spacing: 25,
                  children: [
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        padding: EdgeInsets.only(left: 16),
                        itemCount: movies?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              context.read<BrowseBloc>().add(BrowseMoviesEvent('${widget.genres?[index]}'));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: selectedIndex == index
                                    ? ColorManager.yellow
                                    : ColorManager.black,
                                border: BoxBorder.all(
                                  color: ColorManager.yellow,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${widget.genres?[index]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: selectedIndex == index
                                          ? ColorManager.black
                                          : ColorManager.yellow,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
