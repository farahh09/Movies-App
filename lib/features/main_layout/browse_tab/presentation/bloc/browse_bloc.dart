import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/features/main_layout/browse_tab/domain/usecases/browse_movies_usecase.dart';
import 'package:movies/features/main_layout/browse_tab/presentation/bloc/browse_event.dart';
import 'package:movies/features/main_layout/browse_tab/presentation/bloc/browse_states.dart';
import 'package:movies/features/main_layout/home_tab/presentation/bloc/home_states.dart';

@injectable
class BrowseBloc extends Bloc<BrowseEvents, BrowseStates> {
  BrowseMoviesUseCase browseMoviesUseCase;

  BrowseBloc(this.browseMoviesUseCase) : super(BrowseStates()) {
    on<BrowseMoviesEvent>(_browseMovies);
  }

  Future<void> _browseMovies(
    BrowseMoviesEvent event,
    Emitter<BrowseStates> emit,
  ) async {
    emit(state.copyWith(browseMoviesStatus: RequestStatus.loading));
    try {
      var response = await browseMoviesUseCase.call(event.genre);
      emit(
        state.copyWith(
          browseMoviesStatus: RequestStatus.success,
          movieResponse: response,
        ),
      );
    } catch (e) {
      emit(state.copyWith(browseMoviesStatus: RequestStatus.error));
    }
  }
}
