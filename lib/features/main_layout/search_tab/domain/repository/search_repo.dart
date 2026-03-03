import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

abstract class SearchRepo {
  Future<MovieResponse> searchMovies(String query);
}
