import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/movie_list/movie_list_cubit.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  bool isTvSeries = false;

  @override
  void initState() {
    super.initState();
    // Future.microtask(
    //     () => Provider.of<MovieListNotifier>(context, listen: false)
    //       ..fetchNowPlayingMovies()
    //       ..fetchPopularMovies()
    //       ..fetchTopRatedMovies());

    Future.microtask(() => context.read<MovieListCubit>().loadMovieList());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IconButton(
            //   onPressed: () {
            //     FirebaseCrashlytics.instance.crash();
            //   },
            //   icon: Icon(Icons.search),
            // ),
            Text(
              'Now Playing',
              style: kHeading6,
            ),
            BlocBuilder<MovieListCubit, MovieListState>(
              builder: (context, state) {
                if (state is LoadedMovieListState) {
                  if (state.nowPlaying.isEmpty) {
                    return const Tooltip(
                      message: 'error to load movies',
                      child: Text('Failed'),
                    );
                  }
                  return MovieList(state.nowPlaying);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),

            // Consumer<MovieListNotifier>(builder: (context, data, child) {
            //   final state = data.nowPlayingState;
            //   if (state == RequestState.Loading) {
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else if (state == RequestState.Loaded) {
            //     return MovieList(data.nowPlayingMovies);
            //   } else {
            //     return Text('Failed');
            //   }
            // }),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
            ),
            BlocBuilder<MovieListCubit, MovieListState>(
              builder: (context, state) {
                if (state is LoadedMovieListState) {
                  if (state.popular.isEmpty) {
                    return const Tooltip(
                      message: 'error to load movies',
                      child: Text('Failed'),
                    );
                  }
                  return MovieList(state.popular);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Consumer<MovieListNotifier>(builder: (context, data, child) {
            //   final state = data.popularMoviesState;
            //   if (state == RequestState.Loading) {
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else if (state == RequestState.Loaded) {
            //     return MovieList(data.popularMovies);
            //   } else {
            //     return Text('Failed');
            //   }
            // }),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
            ),
            BlocBuilder<MovieListCubit, MovieListState>(
              builder: (context, state) {
                if (state is LoadedMovieListState) {
                  if (state.topRated.isEmpty) {
                    return const Tooltip(
                      message: 'error to load movies',
                      child: Text('Failed'),
                    );
                  }
                  return MovieList(state.topRated);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Consumer<MovieListNotifier>(builder: (context, data, child) {
            //   final state = data.topRatedMoviesState;
            //   if (state == RequestState.Loading) {
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else if (state == RequestState.Loaded) {
            //     return MovieList(data.topRatedMovies);
            //   } else {
            //     return Text('Failed');
            //   }
            // }),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
