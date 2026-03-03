import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

abstract class BrowseMoviesRepo {
  Future<MovieResponse> browseMovies(String genre);
}
