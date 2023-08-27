import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_popular_movies.dart';
part 'popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;
  PopularMoviesCubit({
    required getPopularMovies,
  })  : _getPopularMovies = getPopularMovies,
        super(
          InitialPopularMoviesState(),
        );
  Future<void> loadPopularMovies() async {
    emit(LoadingPopularMoviesState());
    final getResult = await _getPopularMovies.execute();
    getResult.fold(
      (error) => emit(
        ErrorPopularMoviesState(error.message),
      ),
      (resultMovies) => emit(LoadedPopularMoviesState(resultMovies)),
    );
  }
}
