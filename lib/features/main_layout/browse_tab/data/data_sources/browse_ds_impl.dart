import 'package:injectable/injectable.dart';
import 'package:movies/core/api/api_manager.dart';
import 'package:movies/core/api/endpoints.dart';
import 'package:movies/features/main_layout/browse_tab/data/data_sources/browse_ds.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

@Injectable(as: BrowseDs)
class BrowseDsImpl implements BrowseDs {
  ApiManager apiManager;

  BrowseDsImpl(this.apiManager);

  @override
  Future<MovieResponse> browseMovies(String genre) async{
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
