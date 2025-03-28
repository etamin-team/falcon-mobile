import 'package:dartz/dartz.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';

import '../../../../core/error/failure.dart';

abstract class MnnRepository {
  Future<Either<Failure, List<MnnModel>>> getMnn();
}