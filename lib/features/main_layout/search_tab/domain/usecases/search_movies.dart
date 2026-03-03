import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/home_tab/domain/repository/home_repo.dart';
import 'package:movies/features/main_layout/search_tab/domain/repository/search_repo.dart';

@injectable
class SearchMoviesUseCase {
  SearchRepo searchRepo;

  SearchMoviesUseCase(this.searchRepo);

  Future<MovieResponse> call(String query) => searchRepo.searchMovies(query);
}
