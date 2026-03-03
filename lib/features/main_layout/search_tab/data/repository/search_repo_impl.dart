import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/search_tab/data/data_sources/search_ds.dart';
import 'package:movies/features/main_layout/search_tab/domain/repository/search_repo.dart';

@Injectable(as: SearchRepo)
class SearchRepoImpl implements SearchRepo {
  SearchDs searchDs;

  SearchRepoImpl(this.searchDs);

  @override
  searchMovies(String query) {
    try {
      return searchDs.searchMovies(query);
    } catch (e) {
      rethrow;
    }
  }
}
