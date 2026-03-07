import 'package:movies/features/main_layout/home_tab/data/models/movie_model.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';
import 'package:movies/features/movie_details_screen/data/models/movie_details_model.dart';

class MovieDetailsStates {
  RequestStatus? getMovieDetailsStatus;
  String? getMovieDetailsErrorMessage;
  MovieDetailsResponse? movieDetailsResponse;

  RequestStatus? getMoviesSuggestionStatus;
  String? getMoviesSuggestionErrorMessage;
  MovieResponse? moviesSuggestionResponse;


  MovieDetailsStates({
    this.getMovieDetailsStatus = RequestStatus.init,
    this.getMovieDetailsErrorMessage,
    this.movieDetailsResponse,
    this.getMoviesSuggestionStatus = RequestStatus.init,
    this.getMoviesSuggestionErrorMessage,
    this.moviesSuggestionResponse,
  });

  MovieDetailsStates copyWith({
    RequestStatus? getMovieDetailsStatus,
    String? getMovieDetailsErrorMessage,
    MovieDetailsResponse? movieDetailsResponse,
    RequestStatus? getMoviesSuggestionStatus,
    String? getMoviesSuggestionErrorMessage,
    MovieResponse? moviesSuggestionResponse,

  }) {
    return MovieDetailsStates(
      getMovieDetailsStatus: getMovieDetailsStatus ?? this.getMovieDetailsStatus,
      getMovieDetailsErrorMessage: getMovieDetailsErrorMessage ?? this.getMovieDetailsErrorMessage,
      movieDetailsResponse: movieDetailsResponse ?? this.movieDetailsResponse,
      getMoviesSuggestionStatus: getMoviesSuggestionStatus ?? this.getMoviesSuggestionStatus,
      getMoviesSuggestionErrorMessage: getMoviesSuggestionErrorMessage ?? this.getMoviesSuggestionErrorMessage,
      moviesSuggestionResponse: moviesSuggestionResponse ?? this.moviesSuggestionResponse,
    );
  }
}