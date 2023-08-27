import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status%20_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/search_movies/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/search_tv/search_tvs_bloc.dart';
import 'package:ditonton/presentation/cubit/detail_movies/detail_movies_cubit.dart';
import 'package:ditonton/presentation/cubit/detail_tv/detail_tv_cubit.dart';
import 'package:ditonton/presentation/cubit/movie_list/movie_list_cubit.dart';
import 'package:ditonton/presentation/cubit/now_playing_tv/now_playing_tvs_cubit.dart';
import 'package:ditonton/presentation/cubit/popular_movies/popular_movies_cubit.dart';
import 'package:ditonton/presentation/cubit/popular_tvs/popular_tvs_cubit.dart';
import 'package:ditonton/presentation/cubit/top_rated_TV/top_rated_tvs_cubit.dart';
import 'package:ditonton/presentation/cubit/top_rated_movies/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/cubit/tv_list/tv_list_cubit.dart';
import 'package:ditonton/presentation/cubit/watchlist_movies/watchlist_movies_cubit.dart';
import 'package:ditonton/presentation/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';
// import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
// import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
// import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
// import 'package:ditonton/presentation/provider/now_playing_tv_notifier.dart';
// import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
// import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
// import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
// import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
// import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
// import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
// import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
// import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
// import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
  // locator.registerFactory(
  //   () => MovieListNotifier(
  //     getNowPlayingMovies: locator(),
  //     getPopularMovies: locator(),
  //     getTopRatedMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => MovieDetailNotifier(
  //     getMovieDetail: locator(),
  //     getMovieRecommendations: locator(),
  //     getWatchListStatus: locator(),
  //     saveWatchlist: locator(),
  //     removeWatchlist: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => MovieSearchNotifier(
  //     searchMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => PopularMoviesNotifier(
  //     locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => TopRatedMoviesNotifier(
  //     getTopRatedMovies: locator(),
  //   ),
  // );
  // locator.registerFactory(
  //   () => WatchlistMovieNotifier(
  //     getWatchlistMovies: locator(),
  //   ),
  // );

  // locator.registerFactory(
  //   () => TVListNotifier(
  //     getPopularTV: locator(),
  //     getTopRatedTV: locator(),
  //     getNowPlayingTV: locator(),
  //   ),
  // );

  // locator.registerFactory(
  //   () => PopularTVNotifier(
  //     locator(),
  //   ),
  // );

  // locator.registerFactory(
  //   () => TopRatedTVNotifier(
  //     getTopRatedTV: locator(),
  //   ),
  // );

  // locator.registerFactory(
  //   () => NowPlayingTVNotifier(
  //     locator(),
  //   ),
  // );

  // locator.registerFactory(
  //   () => TvDetailNotifier(
  //     getTvDetail: locator(),
  //     getTvRecommendations: locator(),
  //     getWatchListStatusTv: locator(),
  //     saveWatchlistTv: locator(),
  //     removeWatchlistTv: locator(),
  //   ),
  // );

  // locator.registerFactory(
  //   () => TvSearchNotifier(
  //     searchTv: locator(),
  //   ),
  // );

  // locator.registerFactory(
  //   () => WatchlistTvNotifier(
  //     getWatchlistTv: locator(),
  //   ),
  // );

  //bloc
  locator.registerFactory<MovieListCubit>(
    () => MovieListCubit(
      getNowPlayingMovies: locator<GetNowPlayingMovies>(),
      getPopularMovies: locator<GetPopularMovies>(),
      getTopRatedMovies: locator<GetTopRatedMovies>(),
    ),
  );

  locator.registerFactory(
    () => DetailMoviesCubit(
      getMovieDetail: locator<GetMovieDetail>(),
      getMovieRecommendations: locator<GetMovieRecommendations>(),
      getWatchListStatus: locator<GetWatchListStatus>(),
      saveWatchlist: locator<SaveWatchlist>(),
      removeWatchlist: locator<RemoveWatchlist>(),
    ),
  );

  locator.registerFactory(
    () => SearchMoviesBloc(
      locator<SearchMovies>(),
    ),
  );

  locator.registerFactory(
    () => TopRatedMoviesCubit(
      getTopRatedMovies: locator<GetTopRatedMovies>(),
    ),
  );

  locator.registerFactory(
    () => PopularMoviesCubit(
      getPopularMovies: locator<GetPopularMovies>(),
    ),
  );

  locator.registerFactory(
    () => WatchlistMoviesCubit(
      getWatchlistMovies: locator<GetWatchlistMovies>(),
    ),
  );

  locator.registerFactory(
    () => PopularTvsCubit(
      getPopularTvs: locator<GetPopularTV>(),
    ),
  );

  locator.registerFactory(
    () => TvListCubit(
      getNowPlayingTvs: locator<GetNowPlayingTV>(),
      getPopularTvs: locator<GetPopularTV>(),
      getTopRatedTvs: locator<GetTopRatedTV>(),
    ),
  );

  locator.registerFactory(
    () => DetailTvCubit(
      getTvDetail: locator<GetTvDetail>(),
      getTvRecommendations: locator<GetTvRecommendations>(),
      getWatchListStatus: locator<GetWatchListStatusTv>(),
      saveWatchlist: locator<SaveWatchlistTv>(),
      removeWatchlist: locator<RemoveWatchlistTv>(),
    ),
  );

  locator.registerFactory(
    () => SearchTvsBloc(
      locator<SearchTv>(),
    ),
  );

  locator.registerFactory(
    () => TopRatedTvsCubit(
      getTopRatedTvs: locator<GetTopRatedTV>(),
    ),
  );

  locator.registerFactory(
    () => NowPlayingTvsCubit(
      getTopRatedTvs: locator<GetNowPlayingTV>(),
    ),
  );

  locator.registerFactory(
    () => WatchlistTvsCubit(
      getWatchlistTvs: locator<GetWatchlistTv>(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetPopularTV(locator()));

  locator.registerLazySingleton(() => GetTopRatedTV(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTV(locator()));

  locator.registerLazySingleton(() => GetTvDetail(locator()));

  locator.registerLazySingleton(() => GetTvRecommendations(locator()));

  locator.registerLazySingleton(() => SearchTv(locator()));

  locator.registerLazySingleton(() => GetWatchlistTv(locator()));

  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));

  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));

  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<TVRepository>(
    () => TvRepositoryImpl(
      tvRemoteDataSource: locator(),
      tvLocalDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // data sources
  locator.registerLazySingleton<TVRemoteDataSource>(
      () => TVRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
