import 'package:ditonton/presentation/cubit/popular_movies/popular_movies_cubit.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() =>
    //     Provider.of<PopularMoviesNotifier>(context, listen: false)
    //         .fetchPopularMovies());
    Future.microtask(
      () => context.read<PopularMoviesCubit>().loadPopularMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            // Consumer<PopularMoviesNotifier>(
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
            BlocBuilder<PopularMoviesCubit, PopularMoviesState>(
          builder: (context, state) {
            final state = context.watch<PopularMoviesCubit>().state;
            if (state is ErrorPopularMoviesState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
            if (state is LoadedPopularMoviesState) {
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
