import 'package:flutter_persistence_alura/services/interceptors/logging_interceptors.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

final Client client = InterceptedClient.build(
  interceptors: [
    LoggingInterceptor(),
  ],
);

final String baseURL = "http://192.168.0.9:8080/transactions";