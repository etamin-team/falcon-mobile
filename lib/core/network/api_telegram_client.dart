import 'package:dio/dio.dart';

class ApiTelegramClient {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://209.38.109.22:8083"));

  Future<bool> sendMessage({
    required String number,
    required String message,
  }) async {
    final String path = "/telegram/send-message";
    final Response response = await dio.post(
      path,
      queryParameters: {
        "number": number,
        "message": message,
      },
    );
    print(response.toString());
    try {
      final Response response = await dio.post(
        path,
        queryParameters: {
          "number": number,
          "message": message,
        },
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        print("Error: ${response.data}");
        return false; // Failure case
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
