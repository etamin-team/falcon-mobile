import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/agent_goal_model.dart';
import 'package:wm_doctor/features/med_agent/home/data/model/doctors_model.dart';

abstract class AgentHomeRepository{
  Future<Either<Failure,AgentGoalModel>>getAgentGoal();
  Future<Either<Failure,List<DoctorsModel>>>getDoctors();
}