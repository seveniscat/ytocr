import 'package:dio/dio.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('----- REQUEST BEGIN -----\n'
        'URL: ${options.uri}\n'
        'Method: ${options.method}\n'
        'Headers: ${options.headers}\n'
        'Data: ${options.data}\n'
        '----- REQUEST END -----');
    handler.next(options);
  }

  @override
  void onResponse(Response response,
      ResponseInterceptorHandler handler,) {
    print('----- RESPONSE BEGIN -----\n'
        'Status Code: ${response.statusCode}\n'
        'Headers: ${response.headers}\n'
        'Data: ${response.data}\n'
        '----- RESPONSE END -----');
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('----- ERROR BEGIN -----\n'
        'Error Type: ${err.type}\n'
        'Message: ${err.message}\n'
        'Stack Trace: ${err.stackTrace}\n'
        '----- ERROR END -----');
    handler.next(err);
  }
}