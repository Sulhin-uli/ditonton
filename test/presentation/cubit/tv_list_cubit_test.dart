import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/cubit/tv_list/tv_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'tv_list_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTV,
  GetPopularTV,
  GetTopRatedTV,
])
main() {
  late TvListCubit cubit;
  late MockGetNowPlayingTV getNowPlayingTvs;
  late MockGetPopularTV getPopularTvs;
  late MockGetTopRatedTV getTopRatedTvs;
  setUp(() {
    getNowPlayingTvs = MockGetNowPlayingTV();
    getTopRatedTvs = MockGetTopRatedTV();
    getPopularTvs = MockGetPopularTV();
    cubit = TvListCubit(
      getNowPlayingTvs: getNowPlayingTvs,
      getPopularTvs: getPopularTvs,
      getTopRatedTvs: getTopRatedTvs,
    );
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialTvListStates(),
    );
  });
  blocTest<TvListCubit, TvListState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getNowPlayingTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );
      when(getTopRatedTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );
      when(getPopularTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );

      return cubit;
    },
    act: (cubit) => cubit.loadTvList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTvListState(),
      LoadedTvListState(
          nowPlaying: [testTv], popular: [testTv], topRated: [testTv]),
    ],
  );
  blocTest<TvListCubit, TvListState>(
    "The cubit should emit a LoadedState with one empty array when is called",
    build: () {
      when(getNowPlayingTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );
      when(getTopRatedTvs.execute()).thenAnswer(
        (_) async => Left(ConnectionFailure("cannot connect to network")),
      );
      when(getPopularTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );

      return cubit;
    },
    act: (cubit) => cubit.loadTvList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTvListState(),
      LoadedTvListState(
          nowPlaying: [testTv], popular: [testTv], topRated: const []),
    ],
  );
  blocTest<TvListCubit, TvListState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getNowPlayingTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      when(getTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      when(getPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadTvList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTvListState(),
      const ErrorTvListState(ErrorTvListState.defaultMessage),
    ],
  );
  tearDown(() => cubit.close());
}
