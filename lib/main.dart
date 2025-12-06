import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitamind_mobile/pages/splash_screen.dart';
import 'package:vitamind_mobile/themes/color.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vitamind',
      theme: ThemeData(
        primaryColor: AppColors.primary,
      ),
      home: const SplashScreen(),
    );
  }
}
