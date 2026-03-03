import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/home_tab/data/data_sources/home_ds.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/home_tab/domain/repository/home_repo.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  HomeDs homeDs;

  HomeRepoImpl(this.homeDs);

  @override
  Future<MovieResponse> getMoviesByGenre(String genre) async {
    try {
      var result = await homeDs.getMoviesByGenre(genre);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MovieResponse> getMovies() async {
    try {
      var result = await homeDs.getMovies();
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
