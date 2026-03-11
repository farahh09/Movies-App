import 'package:injectable/injectable.dart';
import 'package:movies/core/api/api_manager.dart';
import 'package:movies/core/api/endpoints.dart';
import 'package:movies/features/main_layout/home_tab/data/data_sources/home_ds.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/movie_details_screen/data/data_sources/movie_details_ds.dart';
import 'package:movies/features/movie_details_screen/data/data_sources/movie_details_ds.dart';
import 'package:movies/features/movie_details_screen/data/data_sources/movie_details_ds.dart';
import 'package:movies/features/movie_details_screen/data/data_sources/movie_details_ds.dart';
import 'package:movies/features/movie_details_screen/data/models/movie_details_model.dart';

@Injectable(as: MovieDetailsDs)
class MovieDetailsDsImpl implements MovieDetailsDs {
  ApiManager apiManager;

  MovieDetailsDsImpl(this.apiManager);

  @override
  Future<MovieDetailsResponse> getMoviesDetails(String id) async {
    try {
      var result = await apiManager.get(
        Endpoints.getMovieDetails,
        queryParameters: {"movie_id": id, "with_cast": true,"with_images": true },
      );
      MovieDetailsResponse movieResponse = MovieDetailsResponse.fromJson(result.data);
      return movieResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MovieResponse> getMoviesSuggestion(String id) async {
    try {
      var result = await apiManager.get(
        Endpoints.getSuggestions,
        queryParameters: {"movie_id": id},
      );
      MovieResponse moviesSuggestion = MovieResponse.fromJson(result.data);
      return moviesSuggestion;
    } catch (e) {
      rethrow;
    }
  }
}
