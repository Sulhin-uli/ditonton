import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/cubit/top_rated_TV/top_rated_tvs_cubit.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects_tv.dart';

class MockTopRatedTvsCubit extends MockCubit<TopRatedTvsState>
    implements TopRatedTvsCubit {}

class FakeLoadingTopRatedTvsState extends Fake
    implements LoadingTopRatedTvsState {}

class FakeLoadedTopRatedTvsState extends Fake
    implements LoadedTopRatedTvsState {}

class FakeErrorTopRatedTvsState extends Fake implements ErrorTopRatedTvsState {}

void main() {
  late MockTopRatedTvsCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingTopRatedTvsState());
    registerFallbackValue(FakeLoadedTopRatedTvsState());
    registerFallbackValue(FakeErrorTopRatedTvsState());
  });
  setUp(() {
    mockCubit = MockTopRatedTvsCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvsCubit>(
      create: (context) => mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final testData = LoadingTopRatedTvsState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadTopRatedTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTVPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView with TvCard when data is loaded',
      (WidgetTester tester) async {
    final testData = LoadedTopRatedTvsState(
      [testTv],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadTopRatedTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final listViewFinder = find.byType(ListView);
    final tvCardFinder = find.byType(TVCard);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTVPage()));

    expect(listViewFinder, findsOneWidget);
    expect(tvCardFinder, findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const testData = ErrorTopRatedTvsState('cannot connect');
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadTopRatedTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTVPage()));

    expect(textFinder, findsOneWidget);
  });
}
