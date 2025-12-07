import 'dart:ui';

class ResultModel {
  final String title;
  final String message;
  final String riskCategory;
  final String buttonText;
  final String imageAsset;
  final Color titleColor;

  ResultModel({
    required this.title,
    required this.message,
    required this.riskCategory,
    required this.buttonText,
    required this.imageAsset,
    required this.titleColor,
  });
}
