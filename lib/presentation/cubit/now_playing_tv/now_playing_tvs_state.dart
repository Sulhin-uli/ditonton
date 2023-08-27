part of 'now_playing_tvs_cubit.dart';

abstract class NowPlayingTvsState extends Equatable {
  const NowPlayingTvsState();
  @override
  List<Object> get props => [];
}

class InitialNowPlayingTvsState extends NowPlayingTvsState {}

class LoadingNowPlayingTvsState extends NowPlayingTvsState {}

class ErrorNowPlayingTvsState extends NowPlayingTvsState {
  final String message;
  const ErrorNowPlayingTvsState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedNowPlayingTvsState extends NowPlayingTvsState {
  final List<TV> tvs;
  const LoadedNowPlayingTvsState(this.tvs);
  @override
  List<Object> get props => [tvs];
}
