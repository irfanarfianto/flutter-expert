import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission_flutter_expert/common/constants.dart';
import 'package:submission_flutter_expert/common/state_enum.dart';
import 'package:submission_flutter_expert/domain/entities/tv.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/airing_tv_today_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/popular_tv_series_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/top_rated_tv_series_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/tv_series_detail_page.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_bloc.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_event.dart';
import 'package:submission_flutter_expert/presentation/blocs/tv/tv_list/tv_list_state.dart';

class HomeTvSeriesPage extends StatefulWidget {
  const HomeTvSeriesPage({super.key});

  @override
  _HomeTvSeriesPageState createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final bloc = context.read<TvListBloc>();
      bloc.add(FetchNowPlayingTvSeries());
      bloc.add(FetchPopularTvSeries());
      bloc.add(FetchTopRatedTvSeries());
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
                _buildSubHeading(
                  title: 'Airing Today',
                  onTap: () => Navigator.pushNamed(
                    context,
                    AiringTodayTvSeriesPage.ROUTE_NAME,
                  ),
                ),
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    if (state.nowPlayingState == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.nowPlayingState == RequestState.Loaded) {
                      return TvSeriesList(state.nowPlayingTvSeries);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
                _buildSubHeading(
                  title: 'Popular',
                  onTap: () => Navigator.pushNamed(
                    context,
                    PopularTvSeriesPage.ROUTE_NAME,
                  ),
                ),
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    if (state.popularState == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.popularState == RequestState.Loaded) {
                      return TvSeriesList(state.popularTvSeries);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
                _buildSubHeading(
                  title: 'Top Rated',
                  onTap: () => Navigator.pushNamed(
                    context,
                    TopRatedTvSeriesPage.ROUTE_NAME,
                  ),
                ),
                BlocBuilder<TvListBloc, TvListState>(
                  builder: (context, state) {
                    if (state.topRatedState == RequestState.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.topRatedState == RequestState.Loaded) {
                      return TvSeriesList(state.topRatedTvSeries);
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

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSeriesItem = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: tvSeriesItem.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSeriesItem.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
