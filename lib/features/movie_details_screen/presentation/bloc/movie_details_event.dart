abstract class MovieDetailsEvents {}

class GetMovieDetailsEvent extends MovieDetailsEvents {
  String id;
  GetMovieDetailsEvent(this.id);
}

class GetMoviesSuggestionEvent extends MovieDetailsEvents {
  String id;
  GetMoviesSuggestionEvent(this.id);
}