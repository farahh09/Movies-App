import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/movie_details_screen/data/data_sources/movie_details_ds.dart';
import 'package:movies/features/movie_details_screen/data/models/movie_details_model.dart';
import 'package:movies/features/movie_details_screen/domain/repository/movie_details_repo.dart';

@Injectable(as: MovieDetailsRepo)
class MovieDetailsRepoImpl implements MovieDetailsRepo {
  MovieDetailsDs movieDetailsDs;

  MovieDetailsRepoImpl(this.movieDetailsDs);

  @override
  Future<MovieDetailsResponse> getMovieDetails(String id) async {
    try {
      var result = await movieDetailsDs.getMoviesDetails(id);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MovieResponse> getMoviesSuggestion(String id) async {
    try {
      var result = await movieDetailsDs.getMoviesSuggestion(id);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
