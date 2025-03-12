import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';

import '../../data/model/contract_model.dart';

abstract class ContractRepository{
 Future<Either<Failure,List<ContractModel>>>getContract();

}