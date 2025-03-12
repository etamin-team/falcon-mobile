import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/sign_up/data/model/workplace_model.dart';

abstract class WorkplaceRepository {
  Future<Either<Failure, List<WorkplaceModel>>> getWorkplace();
}
