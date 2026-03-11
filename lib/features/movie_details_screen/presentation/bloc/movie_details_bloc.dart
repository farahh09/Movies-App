import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/home_tab/domain/usecases/get_movies.dart';
import 'package:movies/features/main_layout/home_tab/domain/usecases/get_movies_by_genre_usecase.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_event.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';
import 'package:movies/features/movie_details_screen/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies/features/movie_details_screen/domain/usecases/get_movies_suggestion_usecase.dart';
import 'package:movies/features/movie_details_screen/presentation/bloc/movie_details_event.dart';
import 'package:movies/features/movie_details_screen/presentation/bloc/movie_details_states.dart';

@injectable
class MovieDetailsBloc extends Bloc<MovieDetailsEvents, MovieDetailsStates> {
  GetMovieDetailsUseCase getMovieDetailsUseCase;
  GetMoviesSuggestionUseCase getMoviesSuggestionUseCase;


  MovieDetailsBloc(this.getMovieDetailsUseCase, this.getMoviesSuggestionUseCase) : super(MovieDetailsStates()) {
    on<GetMovieDetailsEvent>(_getMovieDetails);
    on<GetMoviesSuggestionEvent>(_getMoviesSuggestion);
  }
  Future<void> _getMoviesSuggestion(
      GetMoviesSuggestionEvent event,
      Emitter<MovieDetailsStates> emit,
      ) async {
    emit(state.copyWith(getMoviesSuggestionStatus: RequestStatus.loading));
    try {
      var response = await getMoviesSuggestionUseCase.call(event.id);
      emit(
        state.copyWith(
          getMoviesSuggestionStatus: RequestStatus.success,
          moviesSuggestionResponse: response,
        ),
      );
    } catch (e) {
      emit(state.copyWith(getMoviesSuggestionStatus: RequestStatus.error));
    }

  }

  Future<void> _getMovieDetails(
    GetMovieDetailsEvent event,
    Emitter<MovieDetailsStates> emit,
  ) async {
    emit(state.copyWith(getMovieDetailsStatus: RequestStatus.loading));
    try {
      var response = await getMovieDetailsUseCase.call(event.id);
      emit(
        state.copyWith(
          getMovieDetailsStatus: RequestStatus.success,
          movieDetailsResponse: response,
        ),
      );
    } catch (e) {
      emit(state.copyWith(getMovieDetailsStatus: RequestStatus.error));
    }
  }
}
