import 'package:dio/dio.dart';
import 'package:movies/core/resources/constants_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@lazySingleton
class ApiManager {
  late Dio dio;

  ApiManager() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseURl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );


    dio.interceptors.add(
      PrettyDioLogger(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
      }) async {
    return await dio.get(url, queryParameters: queryParameters);
  }

  Future<Response> post(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    return await dio.post(url, data: data, queryParameters: queryParameters);
  }
}