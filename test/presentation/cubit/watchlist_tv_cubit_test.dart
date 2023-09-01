import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'watchlist_tv_cubit_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
main() {
  late WatchlistTvsCubit cubit;
  late MockGetWatchlistTv getWatchlistTvs;
  setUp(() {
    getWatchlistTvs = MockGetWatchlistTv();
    cubit = WatchlistTvsCubit(getWatchlistTvs: getWatchlistTvs);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialWatchlistTvsState(),
    );
  });
  blocTest<WatchlistTvsCubit, WatchlistTvsState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getWatchlistTvs.execute()).thenAnswer((_) async => Right([testTv]));
      return cubit;
    },
    act: (cubit) => cubit.loadWatchlistTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingWatchlistTvsState(),
      LoadedWatchlistTvsState([testTv]),
    ],
  );
  blocTest<WatchlistTvsCubit, WatchlistTvsState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getWatchlistTvs.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('error')));
      return cubit;
    },
    act: (cubit) => cubit.loadWatchlistTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingWatchlistTvsState(),
      const ErrorWatchlistTvsState('error'),
    ],
  );
  tearDown(() => cubit.close());
}
