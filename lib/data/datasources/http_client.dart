import 'dart:io';
import 'package:http/io_client.dart';
import 'package:submission_flutter_expert/data/datasources/security_context.dart';

class SSLPinningHttpClient {
  static Future<HttpClient> _createHttpClient() async {
    final securityContext = await globalContext;
    HttpClient client = HttpClient(context: securityContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return client;
  }

  static Future<IOClient> createHttpClient() async {
    return IOClient(await _createHttpClient());
  }
}
