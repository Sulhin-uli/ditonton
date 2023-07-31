import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTV])
void main() {
  late MockGetPopularTV mockGetPopulartv;
  late PopularTVNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopulartv = MockGetPopularTV();
    notifier = PopularTVNotifier(mockGetPopulartv)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTv = TV(
      backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
      genreIds: [14, 28],
      id: 1,
      overview:
          'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
      popularity: 60.441,
      posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
      voteAverage: 7.2,
      voteCount: 13507,
      name: "spiderman",
      originCountry: [],
      originalLanguage: "spiderman",
      originalName: "spiderman");

  final tTvList = <TV>[tTv];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopulartv.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    notifier.fetchPopularTV();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopulartv.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchPopularTV();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tv, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopulartv.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTV();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
