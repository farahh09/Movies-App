// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'core/api/api_manager.dart' as _i237;
import 'features/main_layout/browse_tab/data/data_sources/browse_ds.dart'
    as _i984;
import 'features/main_layout/browse_tab/data/data_sources/browse_ds_impl.dart'
    as _i689;
import 'features/main_layout/browse_tab/data/repository/home_repo_impl.dart'
    as _i782;
import 'features/main_layout/browse_tab/domain/repository/browse_repo.dart'
    as _i681;
import 'features/main_layout/browse_tab/domain/usecases/browse_movies_usecase.dart'
    as _i671;
import 'features/main_layout/browse_tab/presentation/bloc/browse_bloc.dart'
    as _i284;
import 'features/main_layout/home_tab/data/data_sources/home_ds.dart' as _i816;
import 'features/main_layout/home_tab/data/data_sources/home_ds_impl.dart'
    as _i883;
import 'features/main_layout/home_tab/data/repository/home_repo_impl.dart'
    as _i185;
import 'features/main_layout/home_tab/domain/repository/home_repo.dart' as _i55;
import 'features/main_layout/home_tab/domain/usecases/get_movies.dart' as _i809;
import 'features/main_layout/home_tab/domain/usecases/get_movies_by_genre_usecase.dart'
    as _i227;
import 'features/main_layout/home_tab/presentation/bloc/home_bloc.dart'
    as _i655;
import 'features/main_layout/search_tab/data/data_sources/search_ds.dart'
    as _i403;
import 'features/main_layout/search_tab/data/data_sources/search_ds_impl.dart'
    as _i906;
import 'features/main_layout/search_tab/data/repository/search_repo_impl.dart'
    as _i613;
import 'features/main_layout/search_tab/domain/repository/search_repo.dart'
    as _i638;
import 'features/main_layout/search_tab/domain/usecases/search_movies.dart'
    as _i292;
import 'features/main_layout/search_tab/presentation/bloc/search_bloc.dart'
    as _i504;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i237.ApiManager>(() => _i237.ApiManager());
    gh.factory<_i816.HomeDs>(() => _i883.HomeDsImpl(gh<_i237.ApiManager>()));
    gh.factory<_i984.BrowseDs>(
      () => _i689.BrowseDsImpl(gh<_i237.ApiManager>()),
    );
    gh.factory<_i403.SearchDs>(
      () => _i906.SearchDsImpl(gh<_i237.ApiManager>()),
    );
    gh.factory<_i681.BrowseMoviesRepo>(
      () => _i782.BrowseRepoImpl(gh<_i984.BrowseDs>()),
    );
    gh.factory<_i55.HomeRepo>(() => _i185.HomeRepoImpl(gh<_i816.HomeDs>()));
    gh.factory<_i671.BrowseMoviesUseCase>(
      () => _i671.BrowseMoviesUseCase(gh<_i681.BrowseMoviesRepo>()),
    );
    gh.factory<_i638.SearchRepo>(
      () => _i613.SearchRepoImpl(gh<_i403.SearchDs>()),
    );
    gh.factory<_i292.SearchMoviesUseCase>(
      () => _i292.SearchMoviesUseCase(gh<_i638.SearchRepo>()),
    );
    gh.factory<_i809.GetMoviesUseCase>(
      () => _i809.GetMoviesUseCase(gh<_i55.HomeRepo>()),
    );
    gh.factory<_i227.GetMoviesByGenreUseCase>(
      () => _i227.GetMoviesByGenreUseCase(gh<_i55.HomeRepo>()),
    );
    gh.factory<_i504.SearchBloc>(
      () => _i504.SearchBloc(gh<_i292.SearchMoviesUseCase>()),
    );
    gh.factory<_i655.HomeBloc>(
      () => _i655.HomeBloc(
        gh<_i227.GetMoviesByGenreUseCase>(),
        gh<_i809.GetMoviesUseCase>(),
      ),
    );
    gh.factory<_i284.BrowseBloc>(
      () => _i284.BrowseBloc(gh<_i671.BrowseMoviesUseCase>()),
    );
    return this;
  }
}
