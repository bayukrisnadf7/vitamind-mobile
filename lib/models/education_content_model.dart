import 'package:flutter/material.dart';

class EducationContent {
  final String title;
  final String content;
  final String imagePath;
  final Widget? imageWidget;

  EducationContent({
    required this.title,
    required this.content,
    required this.imagePath,
    this.imageWidget,
  });
}
