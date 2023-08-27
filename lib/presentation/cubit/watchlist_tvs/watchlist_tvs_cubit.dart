import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
part 'watchlist_tvs_state.dart';

class WatchlistTvsCubit extends Cubit<WatchlistTvsState> {
  final GetWatchlistTv _getWatchlistTvs;
  WatchlistTvsCubit({
    required getWatchlistTvs,
  })  : _getWatchlistTvs = getWatchlistTvs,
        super(
          InitialWatchlistTvsState(),
        );

  Future<void> loadWatchlistTvs() async {
    emit(LoadingWatchlistTvsState());
    final getResult = await _getWatchlistTvs.execute();
    getResult.fold(
      (error) => emit(
        ErrorWatchlistTvsState(
          error.message,
        ),
      ),
      (resultTvs) => emit(LoadedWatchlistTvsState(
        resultTvs,
      )),
    );
  }
}
