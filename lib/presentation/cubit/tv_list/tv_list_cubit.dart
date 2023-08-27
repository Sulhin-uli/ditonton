import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'tv_list_state.dart';

class TvListCubit extends Cubit<TvListState> {
  final GetNowPlayingTV _getNowPlayingTvs;
  final GetTopRatedTV _getTopRatedTvs;
  final GetPopularTV _getPopularTvs;
  TvListCubit({
    required getNowPlayingTvs,
    required getPopularTvs,
    required getTopRatedTvs,
  })  : _getNowPlayingTvs = getNowPlayingTvs,
        _getPopularTvs = getPopularTvs,
        _getTopRatedTvs = getTopRatedTvs,
        super(
          InitialTvListStates(),
        );
  Future<void> loadTvList() async {
    emit(LoadingTvListState());
    final results = await Future.wait<Either<Failure, List<TV>>>([
      _getNowPlayingTvs.execute(),
      _getTopRatedTvs.execute(),
      _getPopularTvs.execute(),
    ]);
    final resultsData = results
        .map<List<TV>>(
          (element) => element.fold(
            (l) => [],
            (r) => r,
          ),
        )
        .toList();
    emit(_getState(resultsData));
  }

  TvListState _getState(List<List<TV>> resultsData) {
    if (resultsData.where((element) => element.isNotEmpty).isEmpty ||
        resultsData.length < 3) {
      return const ErrorTvListState(
        ErrorTvListState.defaultMessage,
      );
    }
    return LoadedTvListState(
      nowPlaying: resultsData.elementAt(0),
      topRated: resultsData.elementAt(1),
      popular: resultsData.elementAt(2),
    );
  }
}
