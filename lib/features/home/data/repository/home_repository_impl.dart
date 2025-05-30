import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/home/data/model/template_model.dart';
import 'package:wm_doctor/features/home/domain/repository/home_repository.dart';

import '../../../../core/utils/dependencies_injection.dart';

class HomeRepositoryImpl implements HomeRepository {

  @override
  Future<Either<Failure, List<TemplateModel>>> getTemplate(
      {required String saved, required String sortBy, required String searchText}) async {

    String path = "/doctor/templates";
    print("📡 API so‘rov yuborilmoqda: $path");

    final request = await sl<ApiClient>().getMethod(
      pathUrl: path,
      isHeader: true,
    );

    if (request.isSuccess) {
      print("✅ API muvaffaqiyatli: ${request.response}");

      try {
        List<TemplateModel> list = request.response.map<TemplateModel>((item) {
          print("🔄 JSON parsing: $item"); // 📌 JSON obyektlarini ekranga chiqarish
          return TemplateModel.fromJson(item);
        }).toList();

        return Right(list);
      } catch (e) {
        print("❌ JSON parsing xatosi: $e");
        return Left(Failure(errorMsg: "JSON parsing xatosi: $e", statusCode: 500));
      }
    } else {
      print("❌ API XATO: ${request.code} - ${request.response}");
      return Left(Failure(errorMsg: request.response.toString(), statusCode: request.code ?? 500));
    }
  }

  @override
  Future<Either<Failure, List<TemplateModel>>> deleteTemplate(
      {required id}) async {

    String path = "/doctor/delete-template/$id";
    print("📡 API so‘rov yuborilmoqda: $path");

    final request = await sl<ApiClient>().deleteMethod(
      pathUrl: path,
      isHeader: true,
    );

    if (request.isSuccess) {
      print("✅ API muvaffaqiyatli: ${request.response}");

      try {
        List<TemplateModel> list = request.response.map<TemplateModel>((item) {
          print("🔄 JSON parsing: $item"); // 📌 JSON obyektlarini ekranga chiqarish
          return TemplateModel.fromJson(item);
        }).toList();

        return Right(list);
      } catch (e) {
        print("❌ JSON parsing xatosi: $e");
        return Left(Failure(errorMsg: "JSON parsing xatosi: $e", statusCode: 500));
      }
    } else {
      print("❌ API XATO: ${request.code} - ${request.response}");
      return Left(Failure(errorMsg: request.response.toString(), statusCode: request.code ?? 500));
    }
  }
}