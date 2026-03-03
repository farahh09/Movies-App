import 'package:injectable/injectable.dart';
import 'package:movies/core/api/api_manager.dart';
import 'package:movies/core/api/endpoints.dart';
import 'package:movies/features/main_layout/home_tab/data/data_sources/home_ds.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

@Injectable(as: HomeDs)
class HomeDsImpl implements HomeDs {
  ApiManager apiManager;

  HomeDsImpl(this.apiManager);

  @override
  Future<MovieResponse> getMovies() async {
    var result = await apiManager.get(Endpoints.getMovies);
    return MovieResponse.fromJson(result.data);
  }

  @override
  Future<MovieResponse> getMoviesByGenre(String genre) async {
    try {
      var result = await apiManager.get(
        Endpoints.getMovies,
        queryParameters: {"genre": genre},
      );
      MovieResponse movieResponse = MovieResponse.fromJson(result.data);
      return movieResponse;
    } catch (e) {
      rethrow;
    }
  }
}
