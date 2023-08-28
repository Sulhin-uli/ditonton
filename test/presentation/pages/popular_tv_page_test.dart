// import 'package:ditonton/domain/entities/movie.dart';
// import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/cubit/popular_tvs/popular_tvs_cubit.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects_tv.dart';

// import 'popular_movies_page_test.mocks.dart';

class MockPopularTvsCubit extends MockCubit<PopularTvsState>
    implements PopularTvsCubit {}

class FakeLoadingPopularTvsState extends Fake
    implements LoadingPopularTvsState {}

class FakeLoadedPopularTvsState extends Fake implements LoadedPopularTvsState {}

class FakeErrorPopularTvsState extends Fake implements ErrorPopularTvsState {}

void main() {
  late MockPopularTvsCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingPopularTvsState());
    registerFallbackValue(FakeLoadedPopularTvsState());
    registerFallbackValue(FakeErrorPopularTvsState());
  });
  setUp(() {
    mockCubit = MockPopularTvsCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvsCubit>(
      create: (BuildContext context) => mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final testData = LoadingPopularTvsState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadPopularTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTVPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView with TvCard when data is loaded',
      (WidgetTester tester) async {
    final testData = LoadedPopularTvsState(
      [testTv],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadPopularTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final listViewFinder = find.byType(ListView);
    final tvCardFinder = find.byType(TVCard);

    await tester.pumpWidget(_makeTestableWidget(PopularTVPage()));

    expect(listViewFinder, findsOneWidget);
    expect(tvCardFinder, findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const testData = ErrorPopularTvsState('cannot connect');
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadPopularTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTVPage()));

    expect(textFinder, findsOneWidget);
  });
}
