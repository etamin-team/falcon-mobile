class StatusModel {
  final dynamic response;
  final int? code;
  final bool isSuccess;
  StatusModel({required this.response, required this.isSuccess, required this.code});
}