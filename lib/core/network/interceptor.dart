import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wm_doctor/core/services/secure_storage.dart';

import '../../features/auth/sign_up/presentation/page/sign_page.dart';
import '../widgets/export.dart';

class CustomErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Agar 401 bo'lsa tokenni yangilash jarayoni boshlanadi
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.endsWith("/auth/login")) {
      // Yangi token olish uchun yangi so'rovni emulyatsiya qilamiz (real API dan foydalaning)
      try {
        print("====================================================");
        final refreshToken =
            await SecureStorage().read(key: 'refreshToken') ?? "";
        final dio = Dio();
        dio.interceptors.clear();
        final response = await dio.post(
            'http://209.38.109.22:8080/api/v1/auth/refresh-token',
            options:
                Options(headers: {"Authorization": "Bearer $refreshToken"}));
        if (response.statusCode == 200) {
          String newAccessToken = response.data['access_token'].toString();
          String newRefreshToken = response.data['refresh_token'].toString();
          await SecureStorage()
              .write(key: "accessToken", value: newAccessToken);
          await SecureStorage()
              .write(key: "refreshToken", value: newRefreshToken);

          // Asl so'rovni qayta yuborish
          err.requestOptions.headers["Authorization"] =
              "Bearer $newAccessToken";
          final cloneRequest = await dio.fetch(err.requestOptions);
          handler.resolve(cloneRequest);
          return;
        }
      } on DioException catch (e) {
        if (e.response!.statusCode == 401) {
          await FlutterSecureStorage().deleteAll();
          Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => SignPage()),
            (route) => false,
          );
        }
      }
    }
    // else if (err.response?.statusCode == 401&&
    //     !err.requestOptions.path.endsWith("/auth/refresh-token") ||
    //         err.response?.statusCode == 403 &&
    //     !err.requestOptions.path.endsWith("/auth/refresh-token")) {
    //   print("===============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //   await FlutterSecureStorage().deleteAll();
    //   Navigator.pushAndRemoveUntil(
    //     navigatorKey.currentContext!,
    //     MaterialPageRoute(builder: (context) => SignPage()),
    //     (route) => false,
    //   );
    // }

    // Xatoni davom ettirish (agar 401 bo‘lmasa)
    handler.next(err);
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
