import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'now_playing_tvs_state.dart';

class NowPlayingTvsCubit extends Cubit<NowPlayingTvsState> {
  final GetNowPlayingTV _getTopRatedTvs;
  NowPlayingTvsCubit({
    required getTopRatedTvs,
  })  : _getTopRatedTvs = getTopRatedTvs,
        super(
          InitialNowPlayingTvsState(),
        );
  Future<void> loadNowPLayingTvs() async {
    emit(LoadingNowPlayingTvsState());
    final getResult = await _getTopRatedTvs.execute();
    getResult.fold(
      (error) => emit(
        ErrorNowPlayingTvsState(error.message),
      ),
      (resultTvs) => emit(
        LoadedNowPlayingTvsState(resultTvs),
      ),
    );
  }
}
