abstract class BrowseEvents {}

class BrowseMoviesEvent extends BrowseEvents {
  String genre;
  BrowseMoviesEvent(this.genre);
}
