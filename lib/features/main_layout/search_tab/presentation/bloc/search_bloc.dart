import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';
import 'package:movies/features/main_layout/search_tab/domain/usecases/search_movies.dart';
import 'package:movies/features/main_layout/search_tab/presentation/bloc/search_event.dart';
import 'package:movies/features/main_layout/search_tab/presentation/bloc/search_states.dart';

@injectable
class SearchBloc extends Bloc<SearchEvents, SearchStates> {
  SearchMoviesUseCase searchMoviesUseCase;

  SearchBloc(this.searchMoviesUseCase) : super(SearchStates()) {
    on<SearchMoviesEvent>(_searchMovies);
  }

  Future<void> _searchMovies(
    SearchMoviesEvent event,
    Emitter<SearchStates> emit,
  ) async {
    emit(state.copyWith(searchMoviesStatus: RequestStatus.loading));
    try {
      var response = await searchMoviesUseCase.call(event.query);
      emit(
        state.copyWith(
          searchMoviesStatus: RequestStatus.success,
          movieResponse: response,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          searchMoviesStatus: RequestStatus.error,
          searchMoviesErrorMessage: e.toString(),
        ),
      );
    }
  }
}
