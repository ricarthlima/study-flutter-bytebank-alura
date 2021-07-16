import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print("REQUEST");
    print("URL: ${data.url}");
    print("Headers: ${data.headers}");
    print("body: ${data.body}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print("RESPONSE");
    print("Status Code: ${data.statusCode}");
    print("Headers: ${data.headers}");
    print("body: ${data.body}");
    return data;
  }
}
