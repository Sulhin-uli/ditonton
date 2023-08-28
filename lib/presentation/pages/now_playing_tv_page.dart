import 'package:ditonton/presentation/cubit/now_playing_tv/now_playing_tvs_cubit.dart';
// import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-tv';

  @override
  _NowPlayingTVPageState createState() => _NowPlayingTVPageState();
}

class _NowPlayingTVPageState extends State<NowPlayingTVPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() =>
    //     Provider.of<NowPlayingTVNotifier>(context, listen: false)
    //         .fetchNowPlayingTV());
    Future.microtask(
      () => context.read<NowPlayingTvsCubit>().loadNowPLayingTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sedang Tayang TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            //  Consumer<NowPlayingTVNotifier>(
            //   builder: (context, data, child) {
            //     if (data.state == RequestState.Loading) {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else if (data.state == RequestState.Loaded) {
            //       return ListView.builder(
            //         itemBuilder: (context, index) {
            //           final tv = data.tv[index];
            //           return TVCard(tv);
            //         },
            //         itemCount: data.tv.length,
            //       );
            //     } else {
            //       return Center(
            //         key: Key('error_message'),
            //         child: Text(data.message),
            //       );
            //     }
            //   },
            // ),
            BlocBuilder<NowPlayingTvsCubit, NowPlayingTvsState>(
          builder: (context, state) {
            final state = context.watch<NowPlayingTvsCubit>().state;
            if (state is ErrorNowPlayingTvsState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
            if (state is LoadedNowPlayingTvsState) {
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
          },
        ),
      ),
    );
  }
}
