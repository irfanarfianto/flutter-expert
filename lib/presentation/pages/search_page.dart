import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/constants.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_search/movie_search_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_search/movie_search_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/movies/movie_search/movie_search_state.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_search/tv_series_search_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_search/tv_series_search_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_search/tv_series_search_state.dart';
import 'package:submission_flutter_expert/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:submission_flutter_expert/presentation/widgets/tv_series_card.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onSubmitted: (query) {
                  context.read<MovieSearchBloc>().add(FetchMovieSearch(query));
                  context.read<TvSeriesSearchBloc>().add(
                        FetchTvSeriesSearch(query),
                      );
                },
                decoration: const InputDecoration(
                  hintText: 'Search title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: 16),
              Text(
                'Search Result (Movies)',
                style: kHeading6,
              ),
              BlocBuilder<MovieSearchBloc, MovieSearchState>(
                builder: (context, state) {
                  if (state.state == RequestState.Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.state == RequestState.Loaded) {
                    final result = state.searchResult;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = state.searchResult[index];
                          return MovieCard(movie);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else if (state.state == RequestState.Error) {
                    return Center(
                      key: const Key('error_message'),
                      child: Text(state.message),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Search Result (TV Series)',
                style: kHeading6,
              ),
              BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
                // Consumer untuk TvSearchNotifier
                builder: (context, state) {
                  if (state.state == RequestState.Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.state == RequestState.Loaded) {
                    final result = state.searchResult;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final tvSeries = state.searchResult[index];
                          return TvSeriesCard(tvSeries);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else if (state.state == RequestState.Error) {
                    return Center(
                      key: const Key('error_message'),
                      child: Text(state.message),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
