

import 'package:equatable/equatable.dart';

class Failure extends Equatable{
  final String errorMsg;
  final int statusCode;
  const Failure({required this.errorMsg,required this.statusCode,});

  @override
  List<Object?> get props => [errorMsg];

}