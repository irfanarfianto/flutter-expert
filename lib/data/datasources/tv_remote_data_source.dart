import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:submission_flutter_expert/common/exception.dart';
import 'package:submission_flutter_expert/data/models/tv_detail_model.dart';
import 'package:submission_flutter_expert/data/models/tv_model.dart';
import 'package:submission_flutter_expert/data/models/tv_response.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getOnTheAirTvSeries();
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getSimilarTvSeries(int id);
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<List<TvSeriesModel>> searchTvSeries(String query);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/themoviedb.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<IOClient> getIOClient() async {
    final context = await globalContext;
    HttpClient httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(httpClient);
  }

  @override
  Future<List<TvSeriesModel>> getOnTheAirTvSeries() async {
    final ioClient = await getIOClient();
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getSimilarTvSeries(int id) async {
    final ioClient = await getIOClient();
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/$id/similar?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final ioClient = await getIOClient();
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final ioClient = await getIOClient();
    final response =
        await ioClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}
