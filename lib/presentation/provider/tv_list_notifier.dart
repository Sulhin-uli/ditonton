import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/get_top_rated_tv.dart';

class TVListNotifier extends ChangeNotifier {
  var _popularTV = <TV>[];
  List<TV> get popularTV => _popularTV;

  RequestState _popularTVState = RequestState.Empty;
  RequestState get popularTVState => _popularTVState;

  var _topRatedTV = <TV>[];
  List<TV> get topRatedTV => _topRatedTV;

  RequestState _topRatedTVState = RequestState.Empty;
  RequestState get topRatedTVState => _topRatedTVState;

  var _nowPlayingTV = <TV>[];
  List<TV> get nowPlayingTV => _nowPlayingTV;

  RequestState _nowPlayingTVState = RequestState.Empty;
  RequestState get nowPlayingTVState => _nowPlayingTVState;

  String _message = '';
  String get message => _message;

  TVListNotifier({
    required this.getPopularTV,
    required this.getTopRatedTV,
    required this.getNowPlayingTV,
  });

  final GetPopularTV getPopularTV;
  final GetTopRatedTV getTopRatedTV;
  final GetNowPlayingTV getNowPlayingTV;

  Future<void> fetchPopularTV() async {
    _popularTVState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTV.execute();
    result.fold(
      (failure) {
        _popularTVState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _popularTVState = RequestState.Loaded;
        _popularTV = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTV() async {
    _topRatedTVState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTV.execute();
    result.fold(
      (failure) {
        _topRatedTVState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topRatedTVState = RequestState.Loaded;
        _topRatedTV = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchNowPlayingTV() async {
    _nowPlayingTVState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTV.execute();
    result.fold(
      (failure) {
        _nowPlayingTVState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _nowPlayingTVState = RequestState.Loaded;
        _nowPlayingTV = tvData;
        notifyListeners();
      },
    );
  }
}