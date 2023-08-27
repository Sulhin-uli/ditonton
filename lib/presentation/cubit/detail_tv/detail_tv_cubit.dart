import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status%20_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'detail_tv_state.dart';

class DetailTvCubit extends Cubit<DetailTvsState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail _getTvDetail;
  final SaveWatchlistTv _saveWatchlist;
  final RemoveWatchlistTv _removeWatchlist;
  final GetTvRecommendations _getTvRecommendations;
  final GetWatchListStatusTv _getWatchListStatus;
  String _message = '';
  String get message => _message;
  DetailTvCubit({
    required GetTvRecommendations getTvRecommendations,
    required GetWatchListStatusTv getWatchListStatus,
    required SaveWatchlistTv saveWatchlist,
    required RemoveWatchlistTv removeWatchlist,
    required GetTvDetail getTvDetail,
  })  : _saveWatchlist = saveWatchlist,
        _removeWatchlist = removeWatchlist,
        _getTvDetail = getTvDetail,
        _getTvRecommendations = getTvRecommendations,
        _getWatchListStatus = getWatchListStatus,
        super(
          InitialDetailTvsState(),
        );

  Future<void> loadDetailTv(int id) async {
    emit(LoadingDetailTvsState());
    final getDetailResult = await _getTvDetail.execute(id);
    final isAddedToWatchlist = await _getWatchListStatus.execute(id);
    final getRecommendationResult = await _getTvRecommendations.execute(id);
    getDetailResult.fold(
      (error) => emit(
        ErrorDetailTvsState(error.message),
      ),
      (detailResult) {
        getRecommendationResult.fold(
          (error) => emit(
            LoadedWithRecommendationErrorDetailTvsState(
              detailResult,
              isAddedToWatchlist,
              error.message,
            ),
          ),
          (recommend) => emit(
            LoadedWithRecommendationListDetailTvsState(
              detailResult,
              isAddedToWatchlist,
              recommend,
            ),
          ),
        );
      },
    );
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    try {
      final result = await _removeWatchlist.execute(tv);
      result.fold(
        (fail) async => _message = fail.message,
        (result) async {
          _message = watchlistRemoveSuccessMessage;

          if (state is LoadedWithRecommendationErrorDetailTvsState) {
            final isAddedToWatchlist = await _getWatchListStatus.execute(tv.id);

            final newState =
                (state as LoadedWithRecommendationErrorDetailTvsState)
                    .copyWith(isAddedtoWatchlistTvs: isAddedToWatchlist);
            emit(newState);
          }
          if (state is LoadedWithRecommendationListDetailTvsState) {
            final isAddedToWatchlist = await _getWatchListStatus.execute(tv.id);

            final newState =
                (state as LoadedWithRecommendationListDetailTvsState)
                    .copyWith(isAddedtoWatchlistTvs: isAddedToWatchlist);
            emit(newState);
          }
        },
      );
    } catch (e) {
      _message = "Failed";
    }
  }

  Future<void> addWatchlist(TvDetail tv) async {
    try {
      final result = await _saveWatchlist.execute(tv);
      result.fold(
        (fail) async => _message = fail.message,
        (result) async {
          _message = watchlistAddSuccessMessage;
          if (state is LoadedWithRecommendationErrorDetailTvsState) {
            final isAddedToWatchlist = await _getWatchListStatus.execute(tv.id);

            final newState =
                (state as LoadedWithRecommendationErrorDetailTvsState)
                    .copyWith(isAddedtoWatchlistTvs: isAddedToWatchlist);
            emit(newState);
          }
          if (state is LoadedWithRecommendationListDetailTvsState) {
            final isAddedToWatchlist = await _getWatchListStatus.execute(tv.id);

            final newState =
                (state as LoadedWithRecommendationListDetailTvsState)
                    .copyWith(isAddedtoWatchlistTvs: isAddedToWatchlist);
            emit(newState);
          }
        },
      );
    } catch (e) {
      _message = "Failed";
    }
  }
}
