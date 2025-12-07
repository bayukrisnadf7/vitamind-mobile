import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vitamind_mobile/models/question_model.dart';
import 'package:vitamind_mobile/models/result_model.dart';

class SkriningController extends GetxController {
  var currentStep = 0.obs;
  var dataDiriStep = 0.obs;
  var currentQuestionId = 1.obs;
  var isLastQuestion = false.obs;
  var questions = <QuestionModel>[].obs;
  var isLoadingQuestions = true.obs;
  var totalScore = 0.obs;
  final int maxScore = 55;

  var pendingEducationText = Rxn<String>();

  @override
  void onInit() {
    loadQuestions();
    super.onInit();
  }

  Future<void> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/dummy_questions.json',
      );
      if (jsonString.isEmpty) {
        throw Exception("File JSON kosong.");
      }
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> questionList = jsonMap['questions'];
      questions.value = questionList
          .map((data) => QuestionModel.fromJson(data))
          .toList();
      isLoadingQuestions.value = false;
    } catch (e) {
      String errorMessage = 'Gagal memuat data pertanyaan: ${e.toString()}';
      Get.snackbar('Error', errorMessage);
      isLoadingQuestions.value = false;
    }
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void nextDataDiriStep() {
    if (dataDiriStep.value < 1) {
      dataDiriStep.value++;
    }
  }

  void previousDataDiriStep() {
    if (dataDiriStep.value > 0) {
      dataDiriStep.value--;
    }
  }

  void answerQuestion(int nextId, int score, String? educationText) {
    totalScore.value += score;
    pendingEducationText.value = educationText;

    if (nextId == -1) {
      isLastQuestion.value = true;
    } else {
      currentQuestionId.value = nextId;
    }
  }

  ResultModel getResult() {
    final double percentage = (totalScore.value / maxScore) * 100;

    if (percentage >= 60) {
      return ResultModel(
        title: 'Risiko Tinggi',
        message:
            'Hasil skrining kamu menunjukkan Risiko Tinggi. Jangan cemas, kamu nggak sendirian. Yuk, segera konsultasi dengan tenaga kesehatan atau psikolog agar kamu dapat dukungan dan penanganan yang tepat. Ingat, semakin cepat ditangani, semakin tenang rasanya.',
        riskCategory: 'Tinggi',
        buttonText: 'Edukasi Pengobatan',
        imageAsset: 'assets/images/risk_high.png',
        titleColor: const Color(0xFFC70039),
      );
    } else if (percentage >= 30) {
      return ResultModel(
        title: 'Risiko Sedang',
        message:
            'Hasil skrining kamu berada di kategori Risiko Sedang. Tetap semangat ya! Kamu bisa menjaga pola hidup sehat, dan bila merasa perlu, jangan ragu untuk terbuka berkonsultasi dengan psikolog agar lebih nyaman dan percaya diri menjaga kesehatanmu.',
        riskCategory: 'Sedang',
        buttonText: 'Edukasi Pengobatan',
        imageAsset: 'assets/images/risk_medium.png',
        titleColor: const Color(0xFFFFC300),
      );
    } else {
      return ResultModel(
        title: 'Risiko Rendah',
        message:
            'Hasil skrining kamu menunjukkan Risiko Rendah. Pertahankan pola hidup sehat dan tetap jaga diri. Kalau kamu ingin lebih tenang, selalu terbuka untuk konsultasi ke psikolog juga nggak ada salahnya. Kesehatan jiwa dan raga sama-sama penting.',
        riskCategory: 'Rendah',
        buttonText: 'Edukasi Pencegahan',
        imageAsset: 'assets/images/risk_low.png',
        titleColor: const Color(0xFF1E8449),
      );
    }
  }

  void resetSkrining() {
    currentStep.value = 0;
    dataDiriStep.value = 0;
    currentQuestionId.value = 1;
    isLastQuestion.value = false;
    totalScore.value = 0;
    pendingEducationText.value = null;
  }
}
