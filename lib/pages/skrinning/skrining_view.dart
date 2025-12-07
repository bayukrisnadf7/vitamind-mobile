import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitamind_mobile/pages/skrinning/informed_consent.dart';
import 'package:vitamind_mobile/pages/skrinning/data_diri_form.dart';
import 'package:vitamind_mobile/pages/skrinning/skrining_controller.dart';

class SkriningView extends StatelessWidget {
  const SkriningView({super.key});

  @override
  Widget build(BuildContext context) {
    final SkriningController controller = Get.put(SkriningController());

    return Obx(() {
      switch (controller.currentStep.value) {
        case 0:
          return const InformedConsent();
        case 1:
          return const DataDiriForm();
        default:
          return const InformedConsent();
      }
    });
  }
}
