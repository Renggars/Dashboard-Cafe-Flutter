// lib/features/pos/data/models/setting_model.dart

class SettingModel {
  final double taxPercentage;
  final bool isTaxActive;
  final double servicePercentage;
  final bool isServiceActive;
  final double discountPercentage;
  final bool isDiscountActive;

  SettingModel({
    required this.taxPercentage,
    required this.isTaxActive,
    required this.servicePercentage,
    required this.isServiceActive,
    required this.discountPercentage,
    required this.isDiscountActive,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        taxPercentage: (json['taxPercentage'] as num).toDouble(),
        isTaxActive: json['isTaxActive'] as bool,
        servicePercentage: (json['servicePercentage'] as num).toDouble(),
        isServiceActive: json['isServiceActive'] as bool,
        discountPercentage: (json['discountPercentage'] as num).toDouble(),
        isDiscountActive: json['isDiscountActive'] as bool,
      );

  Map<String, dynamic> toJson() => {
        "taxPercentage": taxPercentage,
        "isTaxActive": isTaxActive,
        "servicePercentage": servicePercentage,
        "isServiceActive": isServiceActive,
        "discountPercentage": discountPercentage,
        "isDiscountActive": isDiscountActive,
      };
}
