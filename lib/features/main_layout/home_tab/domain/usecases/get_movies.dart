import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/home_tab/domain/repository/home_repo.dart';

@injectable
class GetMoviesUseCase {
  HomeRepo homeRepo;

  GetMoviesUseCase(this.homeRepo);

  Future<MovieResponse> call() => homeRepo.getMovies();
}
