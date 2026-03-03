import 'package:injectable/injectable.dart';
import 'package:movies/core/api/api_manager.dart';
import 'package:movies/core/api/endpoints.dart';
import 'package:movies/features/main_layout/home_tab/data/data_sources/home_ds.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/search_tab/data/data_sources/search_ds.dart';

@Injectable(as: SearchDs)
class SearchDsImpl implements SearchDs {
  ApiManager apiManager;

  SearchDsImpl(this.apiManager);

  @override
  Future<MovieResponse> searchMovies(String query) async {
    try {
      var result = await apiManager.get(
        Endpoints.getMovies,
        queryParameters: {"query_term": query},
      );
      MovieResponse movieResponse = MovieResponse.fromJson(result.data);
      return movieResponse;
    } catch (e) {
      rethrow;
    }
  }
}
