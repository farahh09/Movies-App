import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';

enum RequestStatus { init, loading, success, error }

class HomeStates {
  RequestStatus? getMoviesStatus;
  String? getMoviesErrorMessage;
  MovieResponse? movieResponse;


  HomeStates({
    this.getMoviesStatus = RequestStatus.init,
    this.getMoviesErrorMessage,
    this.movieResponse,
  });

  HomeStates copyWith({
    RequestStatus? getMoviesStatus,
    String? getMoviesErrorMessage,
    MovieResponse? movieResponse,

  }) {
    return HomeStates(
      getMoviesStatus: getMoviesStatus ?? this.getMoviesStatus,
      getMoviesErrorMessage: getMoviesErrorMessage ?? this.getMoviesErrorMessage,
      movieResponse: movieResponse ?? this.movieResponse,
    );
  }
}