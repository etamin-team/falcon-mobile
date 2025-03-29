import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:wm_doctor/core/network/interceptor.dart';
import '../utils/logger.dart';
import 'status_model.dart';
import '../services/secure_storage.dart';

class ApiClient {
  final baseUrl = "http://209.38.109.22:8080/api/v1";

  // final baseUrl = "http://192.168.23.109:8080/api/v1";
  Dio dio = Dio();

  String? token;

  ApiClient() {
    dio = Dio(BaseOptions(baseUrl: baseUrl))
      ..interceptors.add(CustomErrorInterceptor());
    // _initializeInterceptor();
  }

  Future<Map<String, dynamic>> defaultHeader() async {
    token = await SecureStorage().read(key: 'accessToken') ?? "";

    return {
      'Authorization': 'Bearer $token',
      'Accept': '*/*',
    };
  }

  // void _initializeInterceptor() {
  //   dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) async {
  //         options.headers.addAll(await defaultHeader());
  //         return handler.next(options);
  //       },
  //       onError: (error, handler) async {
  //         if ((error.response?.statusCode == 401 || error.response?.statusCode == 403) && error.requestOptions.path != '/auth/refresh-token') {
  //           if (_isRefreshing) {
  //             _retryQueue.add(() => dio.fetch(error.requestOptions).then(
  //                   (response) => handler.resolve(response),
  //               onError: (e) => handler.reject(e),
  //             ));
  //           } else {
  //             _isRefreshing = true;
  //             try {
  //               await refreshToken();
  //               for (var retryRequest in _retryQueue) {
  //                 retryRequest();
  //               }
  //               _retryQueue.clear();
  //               handler.resolve(await dio.fetch(error.requestOptions));
  //             } catch (e) {
  //               await _logoutUser();
  //               handler.reject(DioError(
  //                 requestOptions: error.requestOptions,
  //                 error: 'Log out: Refresh token invalid',
  //               ));
  //             } finally {
  //               _isRefreshing = false;
  //             }
  //           }
  //         } else {
  //           handler.next(error);
  //         }
  //       },
  //     ),
  //   );
  // }
  //
  // Future<void> refreshToken() async {
  //   _refreshToken ??= await SecureStorage().read(key: 'refreshToken');
  //
  //   if (_refreshToken == null) {
  //     throw Exception('Refresh token mavjud emas');
  //   }
  //
  //   final response = await dio.post(
  //     '$baseUrl/auth/refresh-token',
  //     data: {'refresh_token': _refreshToken},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     token = response.data['access_token'];
  //     _refreshToken = response.data['refresh_token'];
  //
  //     await SecureStorage().write(key: 'accessToken', value: token ?? "");
  //     await SecureStorage().write(key: 'refreshToken', value: _refreshToken ?? "");
  //   } else {
  //     throw Exception('Refresh token eskirgan yoki ishlamayapti');
  //   }
  // }
  //
  // Future<void> _logoutUser() async {
  //   await SecureStorage().delete(key: 'accessToken');
  //   await SecureStorage().delete(key: 'refreshToken');
  //   log("Foydalanuvchi logout qilindi.");
  // }

  Future<StatusModel> postMethod({
    required String pathUrl,
    required Map<String, dynamic> body,
    dynamic header,
    required bool isHeader,
    bool anotherLink = false,
  }) async {
    try {
      final res = await dio
          .post(
            anotherLink ? pathUrl : baseUrl + pathUrl,
            options: Options(
              headers: header ??
                  (isHeader
                      ? await defaultHeader()
                      : {"Content_type": "application/json"}),
            ),
            data: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      logger.i(
        "postMethod pathUrl: ${anotherLink ? pathUrl : baseUrl + pathUrl}"
        "\n\n"
        "header: ${header ?? (isHeader ? await defaultHeader() : {
            "Content_type": "application/json"
          })}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${res.statusCode}",
      );

      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        return StatusModel(
            response: res.data, isSuccess: true, code: res.statusCode);
      }
      return StatusModel(
          response: res.data["message"],
          isSuccess: false,
          code: res.statusCode);
    } on DioException catch (e) {
      logger.e(
        "post method pathUrl: $baseUrl$pathUrl"
        "\n\n"
        "header: ${header ?? (isHeader ? await defaultHeader() : {
            "Content_type": "application/json"
          })}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${e.response?.statusCode}"
        "\n\n"
        "response: ${e.response?.data}",
      );
      return dioError(e);
    }
  }

  Future<StatusModel> getMethod({
    required String pathUrl,
    Map<String, dynamic>? header,
    Map<String, dynamic>? body,
    required bool isHeader,
    bool anotherLink = false,
  }) async {
    try {
      final res = await dio
          .get(
            "${anotherLink ? "" : baseUrl}$pathUrl",
            options: Options(
                headers: header ??
                    (isHeader
                        ? await defaultHeader()
                        : {"Content_type": "application/json"})),
            queryParameters: body,
          )
          .timeout(const Duration(seconds: 30));
      logger.i(
        "getMethod pathUrl: ${anotherLink ? pathUrl : baseUrl + pathUrl}"
        "\n\n"
        "header: ${header ?? (isHeader ? await defaultHeader() : {
            "Content_type": "application/json"
          })}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${res.statusCode}"
        "\n\n",
      );

      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        return StatusModel(
            response: res.data, isSuccess: true, code: res.statusCode);
      }
      return StatusModel(
          response: res.data["message"],
          isSuccess: false,
          code: res.statusCode);
    } on DioException catch (e) {
      logger.e(
        "getMethod pathUrl: $baseUrl$pathUrl"
        "\n\n"
        "header: ${header ?? (isHeader ? await defaultHeader() : {
            "Content_type": "application/json"
          })}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${e.response?.statusCode}"
        "\n\n"
        "response: ${e.response?.data}",
      );
      return dioError(e);
    }
  }

  Future<StatusModel> putMethod({
    required String pathUrl,
    required dynamic body,
    dynamic header,
    required bool isHeader,
  }) async {
    try {
      final res = await dio
          .put(
            "$baseUrl$pathUrl",
            options: Options(
                headers: isHeader
                    ? await defaultHeader()
                    : {"Content_type": "application/json"}),
            data: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      logger.i(
        "putMethod pathUrl: $baseUrl$pathUrl"
        "\n\n"
        "header: ${await defaultHeader()}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${res.statusCode}"
        "\n\n",
      );

      if (res.statusCode == 200) {
        return StatusModel(response: res.data, isSuccess: true, code: 200);
      }
      return StatusModel(
          response: res.data["message"],
          isSuccess: false,
          code: res.statusCode);
    } on DioException catch (e) {
      logger.e(
        "putMethod pathUrl: $baseUrl$pathUrl"
        "\n\n"
        "header: ${await defaultHeader()}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${e.response?.statusCode}"
        "\n\n"
        "response: ${e.response?.data}",
      );
      return dioError(e);
    }
  }

  Future<StatusModel> patchMethod({
    required String pathUrl,
    required Map<String, dynamic> body,
    dynamic header,
    required bool isHeader,
  }) async {
    try {
      final res = await dio
          .patch(
            "$baseUrl$pathUrl",
            options: Options(
              headers: isHeader
                  ? await defaultHeader()
                  : {"Content_type": "application/json"},
            ),
            data: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      logger.i(
        "patchMethod pathUrl: $baseUrl$pathUrl"
        "\n\n"
        "header: ${await defaultHeader()}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${res.statusCode}"
        "\n\n",
      );

      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        return StatusModel(
            response: res.data, isSuccess: true, code: res.statusCode);
      }
      return StatusModel(
          response: res.data, isSuccess: false, code: res.statusCode);
    } on DioException catch (e) {
      logger.e(
        "patchMethod pathUrl: $baseUrl$pathUrl"
        "\n\n"
        "header: ${await defaultHeader()}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${e.response?.statusCode}"
        "\n\n"
        "response: ${e.response?.data}",
      );
      return dioError(e);
    }
  }

  Future<StatusModel> deleteMethod({
    required String pathUrl,
    dynamic header,
    required bool isHeader,
    Map<String, dynamic>? body,
  }) async {
    try {
      final res = await dio
          .delete(
            "$baseUrl$pathUrl",
            options: Options(
                headers: isHeader
                    ? await defaultHeader()
                    : {"Content_type": "application/json"}),
            data: jsonEncode(body ?? {}),
          )
          .timeout(const Duration(seconds: 30));
      logger.i(
        "deleteMethod pathUrl: $baseUrl$pathUrl"
        "\n\n"
        "header: ${await defaultHeader()}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${res.statusCode}"
        "\n\n",
      );

      if (res.statusCode == 200) {
        return StatusModel(response: res.data, isSuccess: true, code: 200);
      }
      return StatusModel(
          response: res.data["message"],
          isSuccess: false,
          code: res.statusCode);
    } on DioException catch (e) {
      logger.e(
        "deleteMethod pathUrl: $baseUrl$pathUrl"
        "\n\n"
        "header: ${await defaultHeader()}"
        "\n\n"
        "body: $body"
        "\n\n"
        "code: ${e.response?.statusCode}"
        "\n\n"
        "response: ${e.response?.data}",
      );
      return dioError(e);
    }
  }

  StatusModel dioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return StatusModel(
          response: "Connection Error", isSuccess: false, code: 600);
    }
    if (e.type == DioExceptionType.sendTimeout) {
      return StatusModel(
          response: "Connection Error", isSuccess: false, code: 600);
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return StatusModel(
          response: "Connection Error", isSuccess: false, code: 600);
    }
    if (e.type == DioExceptionType.connectionError) {
      return StatusModel(
          response: "Connection Error", isSuccess: false, code: 700);
    }
    if (e.response!.statusCode! == 404) {
      print('aaaghfhgfahgafhgafhgaf0-------------------------------hagfha');
      return StatusModel(response: null, isSuccess: true, code: 404);
    }
    try {
      if (e.response!.statusCode! >= 500) {
        return StatusModel(
            response: "Server Error", isSuccess: false, code: 500);
      }
    } catch (e) {
      return StatusModel(response: "Server Error", isSuccess: false, code: 900);
    }
    return StatusModel(
        response: e.response?.data,
        isSuccess: false,
        code: e.response?.statusCode ?? 500);
  }
}
