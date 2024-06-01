import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/popular_movies/popular_movies_state.dart';
import 'package:submission_flutter_expert/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final popularMoviesBloc = context.read<PopularMoviesBloc>();
      popularMoviesBloc.add(FetchPopularMovies());
    });
  }

  Future<void> _refresh() async {
    final popularMoviesBloc = context.read<PopularMoviesBloc>();
    popularMoviesBloc.add(FetchPopularMovies());
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Popular Movies'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
            builder: (context, state) {
              if (state.state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.state == RequestState.Loaded) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return MovieCard(movie);
                      },
                      itemCount: state.movies.length,
                    ),
                  ),
                );
              } else {
                return Center(
                  key: const Key('error_message'),
                  child: Text(state.message),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
