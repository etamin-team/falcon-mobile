import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/create_template/data/model/medicine_model.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import 'package:wm_doctor/features/create_template/data/model/upload_template_model.dart';
import 'package:wm_doctor/features/create_template/domain/repository/create_template_repository.dart';
import '../../../../core/utils/dependencies_injection.dart';
import '../../../home/data/model/template_model.dart';

class CreateTemplateRepositoryImpl implements CreateTemplateRepository {
  @override
  Future<Either<Failure, List<MedicineModel>>> getMedicine({required List<String>? inn}) async {
    final request = await sl<ApiClient>().getMethod(
      pathUrl: "/doctor/find-medicines-by-mnn?${ inn?.map((e) => "mnnIds=${Uri.encodeComponent(e)}").join("&")}&exact=false",
      isHeader: true,
    );

    if (request.isSuccess) {
      List<MedicineModel> list = [];
      for (var item in request.response) {
        list.add(MedicineModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, List<MnnModel>>> getMnn({int page = 1, int size = 10}) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/db/mnn/list-page?page=$page&size=$size", isHeader: true);
    if (request.isSuccess) {
      List<MnnModel> list = [];
      for (var item in request.response) {
        list.add(MnnModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> uploadTemplate({required UploadTemplateModel model}) async {
    debugPrint("this is upload data===============>${model.toJson()}");

    final request = await sl<ApiClient>().postMethod(
        pathUrl: "/doctor/create-template",
        body: model.toJson(),
        isHeader: true);

    if (request.isSuccess) {
      return Right(true);
    }

    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  @override
  Future<Either<Failure, bool>> updateTemplate({required TemplateModel model}) async {
    debugPrint("this is update data===============>${model.toJson()}");
    final request = await sl<ApiClient>().putMethod(
        pathUrl: "/doctor/update-template",
        body: model.toJson(),
        isHeader: true);

    if (request.isSuccess) {
      return Right(true);
    }

    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}