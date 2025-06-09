import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/region_model.dart';
import 'package:wm_doctor/features/med_agent/contract/data/model/contract_model.dart';
import 'package:wm_doctor/features/regions/domain/repository/region_repository.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/utils/dependencies_injection.dart';

class RegionsRepositoryImpl implements RegionsRepository {
  @override
  Future<Either<Failure, List<RegionModel>>> getRegions() async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/auth/regions", isHeader: false);
    print("hellllllllllll--------------------");
    if (request.isSuccess) {
      List<RegionModel> list = [];

      for (var item in request.response) {
        list.add(RegionModel.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  Future<Either<Failure, List<RegionModel>>> getRegionById(regionId) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/auth/region?regionId=$regionId", isHeader: true);
    print("------ssssss--------------------------------------------------");
    if (request.isSuccess) {
      print("------nnnnnnn--------------------------------------------------");

      List<RegionModel> list = [];
      
      list.add(RegionModel.fromJson(request.response));
      print(RegionModel.fromJson(request.response).name);
      return Right(list);
    }else{
      return Left(Failure(
          errorMsg: request.response.toString(),
          statusCode: request.code ?? 500));
    }
  }

  Future<Either<Failure, List<District>>> getDistrictsByRegionID(id) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/auth/districts?regionId=$id", isHeader: false);

    if (request.isSuccess) {
      List<District> list = [];

      for (var item in request.response) {
        list.add(District.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }

  Future<Either<Failure, List<WorkPlaceDto>>> getWorkplacesByDistrictId(
      id) async {
    final request = await sl<ApiClient>()
        .getMethod(pathUrl: "/db/workplaces?districtId=$id", isHeader: true);

    if (request.isSuccess) {
      List<WorkPlaceDto> list = [];

      for (var item in request.response) {
        list.add(WorkPlaceDto.fromJson(item));
      }
      return Right(list);
    }
    return Left(Failure(
        errorMsg: request.response.toString(),
        statusCode: request.code ?? 500));
  }
}
