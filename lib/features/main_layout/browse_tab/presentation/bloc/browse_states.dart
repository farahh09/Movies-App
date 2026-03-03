import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';


class BrowseStates {
  RequestStatus? browseMoviesStatus;
  String? browseMoviesErrorMessage;
  MovieResponse? movieResponse;


  BrowseStates({
    this.browseMoviesStatus = RequestStatus.init,
    this.browseMoviesErrorMessage,
    this.movieResponse,
  });

  BrowseStates copyWith({
    RequestStatus? browseMoviesStatus,
    String? browseMoviesErrorMessage,
    MovieResponse? movieResponse,

  }) {
    return BrowseStates(
      browseMoviesStatus: browseMoviesStatus ?? this.browseMoviesStatus,
      browseMoviesErrorMessage: browseMoviesErrorMessage ?? this.browseMoviesErrorMessage,
      movieResponse: movieResponse ?? this.movieResponse,
    );
  }
}