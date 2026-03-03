import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/browse_tab/domain/repository/browse_repo.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

@injectable
class BrowseMoviesUseCase {
  BrowseMoviesRepo browseMoviesRepo;

  BrowseMoviesUseCase(this.browseMoviesRepo);

  Future<MovieResponse> call(String genre) =>
      browseMoviesRepo.browseMovies(genre);
}
