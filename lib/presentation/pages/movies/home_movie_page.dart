import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/constants.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/movie.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_list/movie_list_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_list/movie_list_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_list/movie_list_state.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/movie_detail_page.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/popular_movies_page.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/top_rated_movies_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final movieListBloc = context.read<MovieListBloc>();
      movieListBloc.add(FetchNowPlayingMovies());
      movieListBloc.add(FetchPopularMovies());
      movieListBloc.add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Now Playing',
                  style: kHeading6,
                ),
                BlocBuilder<MovieListBloc, MovieListState>(
                  builder: (context, state) {
                    if (state.nowPlayingState == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.nowPlayingState == RequestState.Loaded) {
                      return MovieList(state.nowPlayingMovies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
                _buildSubHeading(
                  title: 'Popular',
                  onTap: () => Navigator.pushNamed(
                      context, PopularMoviesPage.ROUTE_NAME),
                ),
                BlocBuilder<MovieListBloc, MovieListState>(
                  builder: (context, state) {
                    if (state.popularMoviesState == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.popularMoviesState ==
                        RequestState.Loaded) {
                      return MovieList(state.popularMovies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
                _buildSubHeading(
                  title: 'Top Rated',
                  onTap: () => Navigator.pushNamed(
                      context, TopRatedMoviesPage.ROUTE_NAME),
                ),
                BlocBuilder<MovieListBloc, MovieListState>(
                  builder: (context, state) {
                    if (state.topRatedMoviesState == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.topRatedMoviesState ==
                        RequestState.Loaded) {
                      return MovieList(state.topRatedMovies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
