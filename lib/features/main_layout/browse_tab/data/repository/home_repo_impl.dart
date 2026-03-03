import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/browse_tab/data/data_sources/browse_ds.dart';
import 'package:movies/features/main_layout/browse_tab/domain/repository/browse_repo.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

@Injectable(as: BrowseMoviesRepo)
class BrowseRepoImpl implements BrowseMoviesRepo {
  BrowseDs homeDs;

  BrowseRepoImpl(this.homeDs);

  @override
  Future<MovieResponse> browseMovies(String genre) async {
    try {
      var result = await homeDs.browseMovies(genre);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
