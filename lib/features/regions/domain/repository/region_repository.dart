import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/sign_up/data/model/region_model.dart';

abstract class RegionsRepository{
  Future<Either<Failure, List<RegionModel>>> getRegions();
}