import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/top_rated_movies/top_rated_movies_cubit.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() =>
    //     Provider.of<TopRatedMoviesNotifier>(context, listen: false)
    //         .fetchTopRatedMovies());
    Future.microtask(
      () => context.read<TopRatedMoviesCubit>().loadTopRatedMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            //  Consumer<TopRatedMoviesNotifier>(
            //   builder: (context, data, child) {
            //     if (data.state == RequestState.Loading) {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else if (data.state == RequestState.Loaded) {
            //       return ListView.builder(
            //         itemBuilder: (context, index) {
            //           final movie = data.movies[index];
            //           return MovieCard(movie);
            //         },
            //         itemCount: data.movies.length,
            //       );
            //     } else {
            //       return Center(
            //         key: Key('error_message'),
            //         child: Text(data.message),
            //       );
            //     }
            //   },
            // ),
            BlocBuilder<TopRatedMoviesCubit, TopRatedMoviesState>(
          builder: (context, state) {
            final state = context.watch<TopRatedMoviesCubit>().state;
            if (state is ErrorTopRatedMoviesState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
            if (state is LoadedTopRatedMoviesState) {
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
      ),
    );
  }
}
