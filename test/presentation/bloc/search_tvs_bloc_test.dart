import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/search_tv/search_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'search_tvs_bloc_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late SearchTvsBloc searchTvsBloc;
  late MockSearchTv mockSearchTvs;
  setUp(() {
    mockSearchTvs = MockSearchTv();
    searchTvsBloc = SearchTvsBloc(mockSearchTvs);
  });
  test('initial state should be empty', () {
    expect(searchTvsBloc.state, InitialSearchTvsState());
  });
  const tQuery = 'spiderman';

  blocTest<SearchTvsBloc, SearchTvsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvs.execute(tQuery))
          .thenAnswer((_) async => Right([testTv]));
      return searchTvsBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 600),
    expect: () => [
      LoadingSearchTvsState(),
      LoadedSearchTvsState([testTv]),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(tQuery));
    },
  );
  blocTest<SearchTvsBloc, SearchTvsState>(
    'Should emit [Loading, Error] when data is gotten error',
    build: () {
      when(mockSearchTvs.execute(tQuery)).thenAnswer(
        (_) async => Left(
          ServerFailure('error connection'),
        ),
      );
      return searchTvsBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 600),
    expect: () => [
      LoadingSearchTvsState(),
      const ErrorSearchTvsState('error connection'),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(tQuery));
    },
  );
}
