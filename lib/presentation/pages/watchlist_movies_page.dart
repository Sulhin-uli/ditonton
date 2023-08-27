import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../cubit/watchlist_movies/watchlist_movies_cubit.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() =>
    //     Provider.of<WatchlistMovieNotifier>(context, listen: false)
    //         .fetchWatchlistMovies());
    Future.microtask(
      () => context.read<WatchlistMoviesCubit>().loadWatchlistMovies(),
    );
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(this, ModalRoute.of(context)!);
  // }

  // void didPopNext() {
  //   Provider.of<WatchlistMovieNotifier>(context, listen: false)
  //       .fetchWatchlistMovies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Movies'),
      ),
      body:
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Consumer<WatchlistMovieNotifier>(
          //     builder: (context, data, child) {
          //       if (data.watchlistState == RequestState.Loading) {
          //         return Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       } else if (data.watchlistState == RequestState.Loaded) {
          //         return ListView.builder(
          //           itemBuilder: (context, index) {
          //             final movie = data.watchlistMovies[index];
          //             return MovieCard(movie);
          //           },
          //           itemCount: data.watchlistMovies.length,
          //         );
          //       } else {
          //         return Center(
          //           key: Key('error_message'),
          //           child: Text(data.message),
          //         );
          //       }
          //     },
          //   ),
          // ),
          BlocBuilder<WatchlistMoviesCubit, WatchlistMoviesState>(
        builder: (context, state) {
          final state = context.watch<WatchlistMoviesCubit>().state;
          if (state is ErrorWatchlistMoviesState) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          }
          if (state is LoadedWatchlistMoviesState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieCard(movie);
              },
              itemCount: state.movies.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
