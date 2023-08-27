import 'package:ditonton/presentation/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  const WatchlistTvPage({Key? key}) : super(key: key);

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<WatchlistTvsCubit>().loadWatchlistTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WatchlistTvsCubit>().state;
    if (state is ErrorWatchlistTvsState) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    }
    if (state is LoadedWatchlistTvsState) {
      if (state.tvs.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text("you don't have any watchlist yet"),
          ),
        );
      }
      return ListView.builder(
        itemBuilder: (context, index) {
          final tv = state.tvs[index];
          return TVCard(tv);
        },
        itemCount: state.tvs.length,
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
