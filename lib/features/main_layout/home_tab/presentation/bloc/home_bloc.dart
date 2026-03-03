import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/home_tab/domain/usecases/get_movies.dart';
import 'package:movies/features/main_layout/home_tab/domain/usecases/get_movies_by_genre_usecase.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_event.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';

@injectable
class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  GetMoviesByGenreUseCase getMoviesByGenreUseCase;
  GetMoviesUseCase getMoviesUseCase;


  HomeBloc(this.getMoviesByGenreUseCase, this.getMoviesUseCase) : super(HomeStates()) {
    on<GetMoviesByGenreEvent>(_getMoviesByGenre);
    on<GetMoviesEvent>(_getMovies);

  }

  Future<void> _getMovies(GetMoviesEvent event, Emitter<HomeStates> emit) async {
    emit(state.copyWith(getMoviesStatus: RequestStatus.loading));
    try {
      var response = await getMoviesUseCase.call();
      emit(
        state.copyWith(
          getMoviesStatus: RequestStatus.success,
          movieResponse: response,
        ),
      );
    } catch (e) {
      emit(state.copyWith(getMoviesStatus: RequestStatus.error));
    }
  }
  Future<void> _getMoviesByGenre(GetMoviesByGenreEvent event, Emitter<HomeStates> emit) async {
    emit(state.copyWith(getMoviesStatus: RequestStatus.loading));
    try {
      var response = await getMoviesByGenreUseCase.call(event.genre);
      emit(
        state.copyWith(
          getMoviesStatus: RequestStatus.success,
          movieResponse: response,
        ),
      );
    } catch (e) {
      emit(state.copyWith(getMoviesStatus: RequestStatus.error));
    }
  }
}
