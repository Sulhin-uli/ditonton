import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/cubit/detail_movies/detail_movies_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<DetailMoviesCubit>().loadDetailMovies(
            widget.id,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DetailMoviesCubit>().state;
    if (state is LoadedWithRecommendationListDetailMoviesState) {
      return SafeArea(
        child: DetailContent(
          state.movieDetail,
          state.recommendationMovies,
          state.isAddedtoWatchlistMovies,
        ),
      );
    }
    if (state is LoadedWithRecommendationErrorDetailMoviesState) {
      return SafeArea(
        child: DetailContent(
          state.movieDetail,
          const [],
          state.isAddedtoWatchlistMovies,
          recommendationErrorMessage: state.recommendationError,
        ),
      );
    }
    if (state is ErrorDetailMoviesState) {
      return Tooltip(
        message: 'error message',
        child: Text(state.message),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;
  final String recommendationErrorMessage;
  const DetailContent(
    this.movie,
    this.recommendations,
    this.isAddedWatchlist, {
    Key? key,
    this.recommendationErrorMessage = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await context
                                      .read<DetailMoviesCubit>()
                                      .addWatchlist(movie);
                                } else {
                                  await context
                                      .read<DetailMoviesCubit>()
                                      .removeFromWatchlist(movie);
                                }

                                final message =
                                    context.read<DetailMoviesCubit>().message;

                                if (message ==
                                        DetailMoviesCubit
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        DetailMoviesCubit
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _RecommendationSection(
                              recommendations: recommendations,
                              recommendationErrorMessage:
                                  recommendationErrorMessage,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _RecommendationSection extends StatelessWidget {
  const _RecommendationSection({
    Key? key,
    required this.recommendations,
    required this.recommendationErrorMessage,
  }) : super(key: key);
  final String recommendationErrorMessage;

  final List<Movie> recommendations;

  @override
  Widget build(BuildContext context) {
    if (recommendationErrorMessage.isNotEmpty) {
      return Tooltip(
        message: 'Recommendation error',
        child: Text(recommendationErrorMessage),
      );
    }
    if (recommendations.isEmpty) {
      return const Tooltip(
        message: 'Recommendation empty',
        child: SizedBox(),
      );
    }

    return SizedBox(
      height: 150,
      child: Tooltip(
        message: 'Recommendation list',
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final movie = recommendations[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Tooltip(
                message: 'Recommendation item ${index + 1}',
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
                      arguments: movie.id,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: recommendations.length,
        ),
      ),
    );
  }
}
