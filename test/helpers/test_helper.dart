import 'package:http/io_client.dart';
import 'package:submission_flutter_expert/data/datasources/db/database_helper.dart';
import 'package:submission_flutter_expert/data/datasources/movie_local_data_source.dart';
import 'package:submission_flutter_expert/data/datasources/movie_remote_data_source.dart';
import 'package:submission_flutter_expert/data/datasources/tv_local_data_source.dart';
import 'package:submission_flutter_expert/data/datasources/tv_remote_data_source.dart';
import 'package:submission_flutter_expert/domain/repositories/movie_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:submission_flutter_expert/domain/repositories/tv_repository.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  TvSeriesRepository,
  TvSeriesRemoteDataSource,
  TvLocalDataSource,
], customMocks: [
  MockSpec<IOClient>(as: #MockHttpClient)
])
void main() {}
