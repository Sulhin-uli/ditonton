import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv.dart';
part 'popular_tvs_state.dart';

class PopularTvsCubit extends Cubit<PopularTvsState> {
  final GetPopularTV _getPopularTvs;
  PopularTvsCubit({
    required getPopularTvs,
  })  : _getPopularTvs = getPopularTvs,
        super(
          InitialPopularTvsState(),
        );
  Future<void> loadPopularTvs() async {
    emit(LoadingPopularTvsState());
    final getResult = await _getPopularTvs.execute();
    getResult.fold(
      (error) => emit(
        ErrorPopularTvsState(error.message),
      ),
      (resultTvs) => emit(LoadedPopularTvsState(resultTvs)),
    );
  }
}
