import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/cubit/top_rated_TV/top_rated_tvs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'top_rated_tv_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedTV])
main() {
  late TopRatedTvsCubit cubit;
  late MockGetTopRatedTV getTopRatedTvs;
  setUp(() {
    getTopRatedTvs = MockGetTopRatedTV();
    cubit = TopRatedTvsCubit(getTopRatedTvs: getTopRatedTvs);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialTopRatedTvsState(),
    );
  });
  blocTest<TopRatedTvsCubit, TopRatedTvsState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getTopRatedTvs.execute()).thenAnswer((_) async => Right([testTv]));
      return cubit;
    },
    act: (cubit) => cubit.loadTopRatedTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTopRatedTvsState(),
      LoadedTopRatedTvsState([testTv]),
    ],
  );
  blocTest<TopRatedTvsCubit, TopRatedTvsState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadTopRatedTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTopRatedTvsState(),
      const ErrorTopRatedTvsState('server error'),
    ],
  );
  tearDown(() => cubit.close());
}
