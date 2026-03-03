import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

abstract class HomeDs {

  Future<MovieResponse> getMovies();
  Future<MovieResponse> getMoviesByGenre(String genre);
}
