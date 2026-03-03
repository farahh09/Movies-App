import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

abstract class SearchDs {
  Future<MovieResponse> searchMovies(String query);
}
