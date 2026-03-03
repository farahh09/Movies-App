abstract class HomeEvents {}

class GetMoviesByGenreEvent extends HomeEvents {
  String genre;
  GetMoviesByGenreEvent(this.genre);
}

class GetMoviesEvent extends HomeEvents {

  GetMoviesEvent();
}