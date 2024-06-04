import 'dart:convert';

import 'package:submission_flutter_expert/data/datasources/tv_remote_data_source.dart';
import 'package:submission_flutter_expert/data/models/tv_detail_model.dart';
import 'package:submission_flutter_expert/data/models/tv_response.dart';
import 'package:submission_flutter_expert/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(mockHttpClient);
  });

  group('get On The Air TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/now_playing.json')))
        .tvSeriesList;

    test('should return list of TV Series when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/now_playing.json'), 200));

      final result = await dataSource.getOnTheAirTvSeries();

      expect(result, equals(tTvSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getOnTheAirTvSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/popular.json')))
        .tvSeriesList;

    test('should return list of TV Series when response is success (200)',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular.json'), 200));

      final result = await dataSource.getPopularTvSeries();

      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getPopularTvSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated.json')))
        .tvSeriesList;

    test('should return list of TV Series when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated.json'), 200));

      final result = await dataSource.getTopRatedTvSeries();

      expect(result, tTvSeriesList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTopRatedTvSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series detail', () {
    const tId = 1;
    final tTvDetail = TvSeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/movie_detail.json')));

    test('should return TV Series detail when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/movie_detail.json'), 200));

      final result = await dataSource.getTvSeriesDetail(tId);

      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvSeriesDetail(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series recommendations', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/movie_recommendations.json')))
        .tvSeriesList;
    const tId = 1;

    test('should return list of TV Series Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId/similar?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie_recommendations.json'), 200));

      final result = await dataSource.getSimilarTvSeries(tId);

      expect(result, equals(tTvSeriesList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId/similar?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getSimilarTvSeries(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TV Series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/search_spiderman_movie.json')))
        .tvSeriesList;
    const tQuery = 'Breaking Bad';

    test('should return list of TV Series when response code is 200', () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_spiderman_movie.json'), 200));

      final result = await dataSource.searchTvSeries(tQuery);

      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.searchTvSeries(tQuery);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
