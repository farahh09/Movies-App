import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';

class SearchStates {
  RequestStatus? searchMoviesStatus;
  String? searchMoviesErrorMessage;
  MovieResponse? movieResponse;


  SearchStates({
    this.searchMoviesStatus = RequestStatus.init,
    this.searchMoviesErrorMessage,
    this.movieResponse,
  });

  SearchStates copyWith({
    RequestStatus? searchMoviesStatus,
    String? searchMoviesErrorMessage,
    MovieResponse? movieResponse,

  }) {
    return SearchStates(
      searchMoviesStatus: searchMoviesStatus ?? this.searchMoviesStatus,
      searchMoviesErrorMessage: searchMoviesErrorMessage ?? this.searchMoviesErrorMessage,
      movieResponse: movieResponse ?? this.movieResponse,
    );
  }
}