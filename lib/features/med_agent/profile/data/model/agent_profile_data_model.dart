class AgentProfileDataModel {
  final int? id;
  final int? allConnectedDoctors;
  final int? connectedDoctorsThisMonth;
  final int? allConnectedContracts;
  final int? connectedContractsThisMonth;
  final int? writtenRecipesThisMonth;
  final int? writtenMedicinesThisMonth;

  AgentProfileDataModel({
    this.id,
    this.allConnectedDoctors,
    this.connectedDoctorsThisMonth,
    this.allConnectedContracts,
    this.connectedContractsThisMonth,
    this.writtenRecipesThisMonth,
    this.writtenMedicinesThisMonth,
  });

  /// JSON obyektni `AgentProfileDataModel` obyektiga o‘tkazish
  factory AgentProfileDataModel.fromJson(Map<String, dynamic> json) {
    return AgentProfileDataModel(
      id: json['id'],
      allConnectedDoctors: json['allConnectedDoctors'],
      connectedDoctorsThisMonth: json['connectedDoctorsThisMonth'],
      allConnectedContracts: json['allConnectedContracts'],
      connectedContractsThisMonth: json['connectedContractsThisMonth'],
      writtenRecipesThisMonth: json['writtenRecipesThisMonth'],
      writtenMedicinesThisMonth: json['writtenMedicinesThisMonth'],
    );
  }

  /// `AgentProfileDataModel` obyektini JSON formatga o‘tkazish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'allConnectedDoctors': allConnectedDoctors,
      'connectedDoctorsThisMonth': connectedDoctorsThisMonth,
      'allConnectedContracts': allConnectedContracts,
      'connectedContractsThisMonth': connectedContractsThisMonth,
      'writtenRecipesThisMonth': writtenRecipesThisMonth,
      'writtenMedicinesThisMonth': writtenMedicinesThisMonth,
    };
  }
}
