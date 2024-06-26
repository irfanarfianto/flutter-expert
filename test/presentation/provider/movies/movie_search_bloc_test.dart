import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_flutter_expert/common/failure.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/domain/usecases/movies/search_movies.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_search/movie_search_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_search/movie_search_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_search/movie_search_state.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc movieSearchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(mockSearchMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  group('MovieSearchBloc', () {
    test('initial state should be MovieSearchState with RequestState.Empty',
        () {
      expect(movieSearchBloc.state, const MovieSearchState());
    });

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        MovieSearchState(
          state: RequestState.Loaded,
          searchResult: tMovieList,
        ),
      ],
      verify: (_) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        const MovieSearchState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );
  });
}
