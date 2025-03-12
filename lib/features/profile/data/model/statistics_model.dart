class DoctorStatsModel {
  final String? doctorId;
  final int? recipesCreatedThisMonth;
  final double? averageRecipesPerMonth;

  DoctorStatsModel({
    this.doctorId,
    this.recipesCreatedThisMonth,
    this.averageRecipesPerMonth,
  });

  /// JSON'dan obyekt yaratish (fromJson)
  factory DoctorStatsModel.fromJson(Map<String, dynamic> json) {
    return DoctorStatsModel(
      doctorId: json['doctorId'],
      recipesCreatedThisMonth: json['recipesCreatedThisMonth'],
      averageRecipesPerMonth: json['averageRecipesPerMonth'],
    );
  }

  /// Obyektdan JSON yaratish (toJson)
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'recipesCreatedThisMonth': recipesCreatedThisMonth,
      'averageRecipesPerMonth': averageRecipesPerMonth,
    };
  }
}
