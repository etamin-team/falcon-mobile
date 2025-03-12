import 'package:dartz/dartz.dart';
import 'package:wm_doctor/core/error/failure.dart';
import 'package:wm_doctor/features/home/data/model/template_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<TemplateModel>>> getTemplate(
      {required String saved, required String sortBy, required String searchText});
}
