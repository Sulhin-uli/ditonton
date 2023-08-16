import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/search_movies/search_movies_bloc.dart';
import 'package:ditonton/presentation/cubit/detail_movies/detail_movies_cubit.dart';
import 'package:ditonton/presentation/cubit/movie_list/movie_list_cubit.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page%20.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/now_playing_tv_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    // providers: [
    // ChangeNotifierProvider(
    //   create: (_) => di.locator<MovieListNotifier>(),
    // ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<MovieDetailNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<MovieSearchNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<TopRatedMoviesNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<PopularMoviesNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<WatchlistMovieNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<PopularTVNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<TopRatedTVNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<NowPlayingTVNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<TVListNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<TvDetailNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<TvSearchNotifier>(),
    //   ),
    //   ChangeNotifierProvider(
    //     create: (_) => di.locator<WatchlistTvNotifier>(),
    //   ),
    // ],
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieListCubit>(
          create: (context) => di.locator<MovieListCubit>(),
        ),
        BlocProvider<DetailMoviesCubit>(
          create: (_) => di.locator<DetailMoviesCubit>(),
        ),
        BlocProvider<SearchMoviesBloc>(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            // tv
            case PopularTVPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTVPage());
            case TopRatedTVPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTVPage());
            case NowPlayingTVPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => NowPlayingTVPage());
            case SearchTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvPage());
            case WatchlistTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvPage());
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
