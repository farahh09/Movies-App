import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movies/core/resources/color_manager.dart';
import 'package:movies/di.dart';
import 'package:movies/features/main_layout/browse_tab/browse_tab.dart';
import 'package:movies/features/main_layout/home_tab/home_tab.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_bloc.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_event.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';
import 'package:movies/features/main_layout/profile_tab/profile_screen.dart';
import 'package:movies/features/main_layout/search_tab/search_tab.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
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
        create: (context) => getIt<HomeBloc>()..add(GetMoviesEvent()),
        child: BlocConsumer<HomeBloc, HomeStates>(
          listener: (context, state) {
            if (state.getMoviesStatus == RequestStatus.loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }
          },
          builder: (context, state) {
            final movies = state.movieResponse?.data?.movies;
            final genres = movies?.expand((movie) => movie.genres ?? []).toSet().toList();
            genres?.sort();
            List<Widget> tabs = [HomeTab(), SearchTab(), BrowseTab(genres: genres,), ProfileScreen()];
            return Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody: true,
              body: tabs[currentIndex],
              bottomNavigationBar: isKeyboardOpen ? null : MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: SizedBox(
                        height: 60,
                        child: BottomNavigationBar(
                          currentIndex: currentIndex,
                          backgroundColor: ColorManager.darkGrey,
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: ColorManager.yellow,
                          unselectedItemColor: ColorManager.white,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          onTap: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          items: [
                            BottomNavigationBarItem(
                              label: '',
                              icon: ImageIcon(
                                AssetImage('assets/icons/home_ic.png'),
                              ),
                            ),
                            BottomNavigationBarItem(
                              label: '',
                              icon: ImageIcon(
                                AssetImage('assets/icons/search_ic.png'),
                              ),
                            ),
                            BottomNavigationBarItem(
                              label: '',
                              icon: ImageIcon(
                                AssetImage('assets/icons/explore_ic.png'),
                              ),
                            ),
                            BottomNavigationBarItem(
                              label: '',
                              icon: ImageIcon(
                                AssetImage('assets/icons/profile_ic.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}