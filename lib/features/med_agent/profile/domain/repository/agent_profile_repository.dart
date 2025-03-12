import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/profile/data/model/agent_profile_data_model.dart';

abstract class AgentProfileRepository {
  Future<Either<Failure, AgentProfileDataModel>> getProfileData();
}
