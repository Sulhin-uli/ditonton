import 'package:ditonton/presentation/cubit/popular_tvs/popular_tvs_cubit.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTVPageState createState() => _PopularTVPageState();
}

class _PopularTVPageState extends State<PopularTVPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() =>
    //     Provider.of<PopularTVNotifier>(context, listen: false)
    //         .fetchPopularTV());
    Future.microtask(
      () => context.read<PopularTvsCubit>().loadPopularTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            // Consumer<PopularTVNotifier>(
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
            BlocBuilder<PopularTvsCubit, PopularTvsState>(
          builder: (context, state) {
            final state = context.watch<PopularTvsCubit>().state;
            if (state is ErrorPopularTvsState) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
            if (state is LoadedPopularTvsState) {
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
