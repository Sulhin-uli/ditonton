import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTV usecase;
  late MockTVRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTVRepository();
    usecase = GetNowPlayingTV(mockTvRepository);
  });

  final tTv = <TV>[];

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockTvRepository.getNowPlayingTV())
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTv));
  });
}
