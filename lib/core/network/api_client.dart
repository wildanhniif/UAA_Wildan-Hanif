import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/env_config.dart'; // Import config

class ApiClient {
  final Dio dio;
  final Logger logger = Logger();

  ApiClient() : dio = Dio() {
    // SEKARANG BASE URL BERUBAH SECARA OTOMATIS SESUAI FLAVOR!
    dio.options.baseUrl = EnvConfig.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // Interceptor Logger — Wajib per kriteria UTS Poin 2
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.i('🌐 REQUEST → [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.i('✅ RESPONSE ← [${response.statusCode}] ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e('❌ ERROR [${e.response?.statusCode}] ${e.requestOptions.uri}');
          logger.e('PESAN: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
