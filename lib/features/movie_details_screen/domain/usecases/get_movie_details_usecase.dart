import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/home_tab/domain/repository/home_repo.dart';
import 'package:movies/features/movie_details_screen/data/models/movie_details_model.dart';
import 'package:movies/features/movie_details_screen/domain/repository/movie_details_repo.dart';

@injectable
class GetMovieDetailsUseCase {
  MovieDetailsRepo movieDetailsRepo;

  GetMovieDetailsUseCase(this.movieDetailsRepo);

  Future<MovieDetailsResponse> call(String id) => movieDetailsRepo.getMovieDetails(id);
}
