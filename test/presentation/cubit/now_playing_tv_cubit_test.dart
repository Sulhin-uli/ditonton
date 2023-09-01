import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/presentation/cubit/now_playing_tv/now_playing_tvs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import 'tv_list_cubit_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV])
main() {
  late NowPlayingTvsCubit cubit;
  late MockGetNowPlayingTV getTopRatedTvs;
  setUp(() {
    getTopRatedTvs = MockGetNowPlayingTV();
    cubit = NowPlayingTvsCubit(getTopRatedTvs: getTopRatedTvs);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialNowPlayingTvsState(),
    );
  });
  blocTest<NowPlayingTvsCubit, NowPlayingTvsState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getTopRatedTvs.execute()).thenAnswer((_) async => Right([testTv]));
      return cubit;
    },
    act: (cubit) => cubit.loadNowPLayingTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingNowPlayingTvsState(),
      LoadedNowPlayingTvsState([testTv]),
    ],
  );
  blocTest<NowPlayingTvsCubit, NowPlayingTvsState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadNowPLayingTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingNowPlayingTvsState(),
      const ErrorNowPlayingTvsState('server error'),
    ],
  );
  tearDown(() => cubit.close());
}
