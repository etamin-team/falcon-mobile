class MedicineModel {
  final int? id;
  final String? name;
  final String? imageUrl;
  final int? cip;
   int? quantity;
  final double? prescription;
  final String? volume;
  final String? type;
  final List<dynamic>? inn;
  final double? suPercentage;
  final double? suLimit;
  final int? suBall;
  final double? sbPercentage;
  final double? sbLimit;
  final int? sbBall;
  final double? gzPercentage;
  final double? gzLimit;
  final int? gzBall;
  final double? kbPercentage;
  final double? kbLimit;
  final int? kbBall;

  MedicineModel({
    this.id,
    this.name,
    this.imageUrl,
    this.cip,
    this.quantity,
    this.prescription,
    this.volume,
    this.type,
    this.inn,
    this.suPercentage,
    this.suLimit,
    this.suBall,
    this.sbPercentage,
    this.sbLimit,
    this.sbBall,
    this.gzPercentage,
    this.gzLimit,
    this.gzBall,
    this.kbPercentage,
    this.kbLimit,
    this.kbBall,
  });

  /// `fromJson` - JSON dan `Medicine` obyektiga aylantirish
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      cip: json['cip'] as int?,
      quantity: json['quantity'] as int?,
      prescription: json['prescription'] as double?,
      volume: json['volume'] as String?,
      type: json['type'] as String?,
      inn: json['mnn'] as List<dynamic>?,
      suPercentage: (json['suPercentage'] as num?)?.toDouble(),
      suLimit: (json['suLimit'] as num?)?.toDouble(),
      suBall: json['suBall'] as int?,
      sbPercentage: (json['sbPercentage'] as num?)?.toDouble(),
      sbLimit: (json['sbLimit'] as num?)?.toDouble(),
      sbBall: json['sbBall'] as int?,
      gzPercentage: (json['gzPercentage'] as num?)?.toDouble(),
      gzLimit: (json['gzLimit'] as num?)?.toDouble(),
      gzBall: json['gzBall'] as int?,
      kbPercentage: (json['kbPercentage'] as num?)?.toDouble(),
      kbLimit: (json['kbLimit'] as num?)?.toDouble(),
      kbBall: json['kbBall'] as int?,
    );
  }

  /// `toJson` - `Medicine` obyektini JSON formatga o‘tkazish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'cip': cip,
      'quantity': quantity,
      'prescription': prescription,
      'volume': volume,
      'type': type,
      'inn': inn,
      'suPercentage': suPercentage,
      'suLimit': suLimit,
      'suBall': suBall,
      'sbPercentage': sbPercentage,
      'sbLimit': sbLimit,
      'sbBall': sbBall,
      'gzPercentage': gzPercentage,
      'gzLimit': gzLimit,
      'gzBall': gzBall,
      'kbPercentage': kbPercentage,
      'kbLimit': kbLimit,
      'kbBall': kbBall,
    };
  }
}