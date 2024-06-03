import 'package:flutter/material.dart';
import 'package:submission_flutter_expert/presentation/pages/about_page.dart';
import 'package:submission_flutter_expert/presentation/pages/movies/home_movie_page.dart';
import 'package:submission_flutter_expert/presentation/pages/tv/home_tv_series_page.dart';
import 'package:submission_flutter_expert/presentation/pages/search_page.dart';
import 'package:submission_flutter_expert/presentation/pages/watchlist_page.dart';

class HomeMovieTvPage extends StatelessWidget {
  const HomeMovieTvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/circle-g.png'),
                ),
                accountName: Text('Ditonton'),
                accountEmail: Text('ditonton@dicoding.com'),
              ),
              ListTile(
                leading: const Icon(Icons.movie),
                title: const Text('Movies'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: const Text('Watchlist'),
                onTap: () {
                  Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
                },
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
              ),
              // ListTile(
              //   onTap: () {
              //     FirebaseCrashlytics.instance.crash();
              //     Navigator.pushNamed(context, ROUTE_NAME);
              //   },
              //   leading: const Icon(Icons.search),
              //   title: const Text('Search'),
              // ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Ditonton'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
              },
              icon: const Icon(Icons.search),
            )
          ],
          bottom: const TabBar(
              tabs: [
                Tab(text: 'Movies'),
                Tab(text: 'TV Series'),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              indicatorPadding: EdgeInsets.all(5),
              dividerColor: Colors.transparent),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeMoviePage(),
            HomeTvSeriesPage(),
          ],
        ),
      ),
    );
  }
}
