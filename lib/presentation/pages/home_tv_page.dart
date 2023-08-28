import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/cubit/tv_list/tv_list_cubit.dart';
// import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTVPage extends StatefulWidget {
  @override
  _HomeTVPageState createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(
    //   () => Provider.of<TVListNotifier>(context, listen: false)
    //     ..fetchPopularTV()
    //     ..fetchTopRatedTV()
    //     ..fetchNowPlayingTV(),
    // );

    Future.microtask(
      () => context.read<TvListCubit>().loadTvList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTVPage.ROUTE_NAME),
            ),
            BlocBuilder<TvListCubit, TvListState>(
              builder: (context, state) {
                if (state is LoadedTvListState) {
                  if (state.popular.isEmpty) {
                    return const Tooltip(
                      message: 'error to load tvs',
                      child: Text('Failed'),
                    );
                  }
                  return TVList(state.nowPlaying);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Consumer<TVListNotifier>(builder: (context, data, child) {
            //   final state = data.popularTVState;
            //   if (state == RequestState.Loading) {
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else if (state == RequestState.Loaded) {
            //     return TVList(data.popularTV);
            //   } else {
            //     return Text('Failed');
            //   }
            // }),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTVPage.ROUTE_NAME),
            ),
            BlocBuilder<TvListCubit, TvListState>(
              builder: (context, state) {
                if (state is LoadedTvListState) {
                  if (state.topRated.isEmpty) {
                    return const Tooltip(
                      message: 'error to load tvs',
                      child: Text('Failed'),
                    );
                  }
                  return TVList(state.topRated);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Consumer<TVListNotifier>(builder: (context, data, child) {
            //   final state = data.topRatedTVState;
            //   if (state == RequestState.Loading) {
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else if (state == RequestState.Loaded) {
            //     return TVList(data.topRatedTV);
            //   } else {
            //     return Text('Failed');
            //   }
            // }),
            _buildSubHeading(
              title: 'Sedang Tayang',
              onTap: () =>
                  Navigator.pushNamed(context, NowPlayingTVPage.ROUTE_NAME),
            ),
            BlocBuilder<TvListCubit, TvListState>(
              builder: (context, state) {
                if (state is LoadedTvListState) {
                  if (state.nowPlaying.isEmpty) {
                    return const Tooltip(
                      message: 'error to load tvs',
                      child: Text('Failed'),
                    );
                  }
                  return TVList(state.nowPlaying);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Consumer<TVListNotifier>(builder: (context, data, child) {
            //   final state = data.nowPlayingTVState;
            //   if (state == RequestState.Loading) {
            //     return Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   } else if (state == RequestState.Loaded) {
            //     return TVList(data.nowPlayingTV);
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

class TVList extends StatelessWidget {
  final List<TV> tvs;

  TVList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
