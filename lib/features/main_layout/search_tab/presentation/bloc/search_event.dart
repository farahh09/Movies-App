abstract class SearchEvents {}

class SearchMoviesEvent extends SearchEvents {
  String query;

  SearchMoviesEvent(this.query);
}
