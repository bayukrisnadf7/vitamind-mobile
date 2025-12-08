import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitamind_mobile/models/edukasi_model.dart';
import 'package:vitamind_mobile/models/question_model.dart';
import 'package:vitamind_mobile/pages/settings/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitamind_mobile/pages/skrinning/skrining_controller.dart';
import 'package:vitamind_mobile/pages/skrinning/skrining_result_page.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final SkriningController controller = Get.find<SkriningController>();
  String? nama = "";
  final ScrollController _scrollController = ScrollController();
  final List<Widget> chatHistory = [];
  final List<AnswerOption> availableOptions = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadUser();

    if (!controller.isLoadingQuestions.value && !_isInitialized) {
      _scheduleInitialization();
    }

    controller.isLoadingQuestions.listen((loading) {
      if (!loading && !_isInitialized) {
        _scheduleInitialization();
      }
    });

    controller.currentQuestionId.listen((id) {
      if (_isInitialized) {
        _showQuestion(id);
      }
    });

    controller.isLastQuestion.listen((isFinished) {
      if (isFinished) {
        _showFinishModal();
      }
    });
  }

  void _scheduleInitialization() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeChat();
      }
    });
  }

  void _initializeChat() {
    if (!_isInitialized) {
      setState(() {
        _isInitialized = true;
        _showWelcomeMessage();
      });
    }
  }

  void _showWelcomeMessage() {
    _addBotMessage(
      "Hai, selamat datang di VitaMind! Aku VitaBot siap nemenin kamu dalam proses skrining 😊",
    );
    _showQuestion(controller.currentQuestionId.value);
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "";
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  QuestionModel? _getCurrentQuestion(int id) {
    return controller.questions.firstWhereOrNull((q) => q.id == id);
  }

  void _showQuestion(int id) {
    if (controller.isLastQuestion.value || id == -1) {
      if (!controller.isLastQuestion.value) {
        _addBotMessage("Terima kasih, skrining selesai! Silakan lihat hasil.");
      }
      setState(() {
        availableOptions.clear();
      });
      return;
    }

    final question = _getCurrentQuestion(id);
    final eduText = controller.pendingEducationText.value;
    controller.pendingEducationText.value = null;

    if (question != null) {
      setState(() {
        _addBotMessage(question.text, eduText: eduText, questionId: id);
        availableOptions.clear();
        availableOptions.addAll(question.options);
      });
      _scrollToBottom();
    }
  }

  String _getEdukasiContent(String title) {
    switch (title) {
      case "Edukasi mengenai seks bebas":
        return "Seks bebas adalah hubungan seksual yang dilakukan di luar ikatan pernikahan atau tanpa komitmen jangka panjang, seringkali dengan banyak pasangan. Praktik ini sangat berisiko tinggi menularkan Penyakit Menular Seksual (PMS), termasuk HIV/AIDS, sifilis, dan klamidia. Untuk menjaga kesehatan reproduksi, penting untuk selalu mempraktikkan seks aman, seperti penggunaan kondom yang benar dan konsisten. Selain itu, membatasi pasangan atau, yang terbaik, menjaga komitmen pada satu pasangan yang sehat adalah cara paling efektif untuk mengurangi risiko infeksi. Jangan ragu untuk melakukan tes kesehatan rutin jika Anda merasa berisiko.";
      case "Edukasi tentang PMS":
        return "Penyakit Menular Seksual (PMS), atau yang kini sering disebut Infeksi Menular Seksual (IMS), adalah infeksi yang ditularkan melalui kontak intim. Beberapa contoh PMS yang umum meliputi HIV, sifilis, gonore, klamidia, dan herpes genital. Gejala PMS sangat bervariasi; beberapa kasus mungkin tidak menunjukkan gejala sama sekali (asimptomatik), sementara yang lain mungkin mengalami rasa nyeri, gatal, munculnya luka atau ruam, atau keluarnya cairan tidak normal dari organ reproduksi. Pencegahan PMS meliputi penggunaan kondom saat berhubungan, menjaga kebersihan organ intim, menghindari perilaku berisiko seperti berbagi jarum suntik, dan melakukan pemeriksaan kesehatan secara rutin. Deteksi dini sangat penting karena semakin cepat terdiagnosis, semakin besar peluang untuk diobati dan mencegah penularan lebih lanjut.";
      case "Edukasi mengenai Alat Kelamin (jenis - jenis keluhan dan penyakitnya)":
        return "Keluhan pada alat kelamin sering kali menjadi tanda awal adanya infeksi, peradangan, atau masalah kesehatan yang mendasar. Jenis keluhan umum meliputi gatal, rasa terbakar atau nyeri saat buang air kecil (disuria), munculnya luka terbuka (ulkus), benjolan, kutil, atau keluarnya cairan (discharge) yang berbau tidak sedap atau berwarna tidak normal. Penting untuk diperhatikan bahwa setiap keluhan yang tidak normal harus segera diperiksa oleh dokter atau tenaga kesehatan profesional. Jangan pernah mencoba mengobati sendiri, karena diagnosis yang salah dapat memperburuk kondisi atau menunda penanganan penyakit serius. Penanganan yang tepat dan cepat adalah kunci untuk pemulihan dan pencegahan penularan kepada orang lain.";
      case "Pengeritan Anal":
        return "Seks anal membawa risiko penularan HIV yang signifikan lebih tinggi dibandingkan seks vaginal. Alasannya adalah karena lapisan kulit rektum (anus) lebih tipis dan rapuh, sehingga mudah mengalami robekan kecil (mikrolesi) selama aktivitas seksual. Robekan ini menyediakan jalur langsung bagi HIV dan patogen lainnya untuk masuk ke aliran darah. Oleh karena itu, penggunaan kondom yang konsisten dan tepat, bersama dengan penggunaan pelumas (lubricant) berbasis air atau silikon, sangatlah penting untuk mengurangi gesekan dan meminimalkan risiko trauma jaringan. Pelumas harus selalu digunakan karena pelumas alami tubuh tidak memadai untuk mencegah robekan dalam praktik seks anal.";
      default:
        return "Informasi edukasi tidak ditemukan. Silakan hubungi admin jika masalah ini berlanjut.";
    }
  }

  void _handleAnswer(AnswerOption selectedOption) {
    final currentQuestion = _getCurrentQuestion(
      controller.currentQuestionId.value,
    );
    if (currentQuestion == null) return;

    setState(() {
      _addUserMessage(selectedOption.answer);
      availableOptions.clear();
    });

    controller.answerQuestion(
      selectedOption.nextQuestionId,
      selectedOption.value,
      selectedOption.education,
    );
    _scrollToBottom();
  }

  void _addBotMessage(String text, {String? eduText, int? questionId}) {
    TextSpan content;
    final baseStyle = const TextStyle(color: Colors.black, fontSize: 14);

    final Map<int, String> keywordMap = {
      11: "hubungan seksual",
      12: "hubungan seksual",
      101: "penyakit menular seksual",
      102: "alat kelamin",
      303: "seks anal",
    };

    if (eduText != null &&
        questionId != null &&
        keywordMap.containsKey(questionId)) {
      final keyword = keywordMap[questionId]!;
      final index = text.toLowerCase().indexOf(keyword.toLowerCase());

      if (index != -1) {
        content = TextSpan(
          text: text.substring(0, index),
          style: baseStyle,
          children: [
            TextSpan(
              text: text.substring(index, index + keyword.length),
              style: baseStyle.copyWith(
                color: const Color(0xFF4A90E2),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final eduContent = _getEdukasiContent(eduText);
                  showDialog(
                    context: context,
                    builder: (context) =>
                        EdukasiModal(title: eduText, content: eduContent),
                  );
                },
            ),
            TextSpan(
              text: text.substring(index + keyword.length),
              style: baseStyle,
            ),
          ],
        );
      } else {
        content = TextSpan(text: text, style: baseStyle);
      }
    } else {
      content = TextSpan(text: text, style: baseStyle);
    }

    chatHistory.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  15,
                ).copyWith(topLeft: Radius.zero),
              ),
              child: Text.rich(content),
            ),
          ],
        ),
      ),
    );
  }

  void _addUserMessage(String text) {
    chatHistory.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(
                  15,
                ).copyWith(topRight: Radius.zero),
              ),
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showFinishModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/finish_modal.png',
                height: 80,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Yeay, skrining kamu sudah selesai!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Yuk, lihat hasilnya sekarang.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.off(() => const SkriningResultPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Lihat Hasil',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          controller.resetSkrining();
          Get.offAllNamed('/');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: const AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.grey[100],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VitaBot',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Online',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.redAccent,
                ),
                onPressed: () => Get.to(() => const Setting()),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Obx(() {
              if (controller.isLoadingQuestions.value) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      return chatHistory[index];
                    },
                  ),
                ),
              );
            }),
            Obx(() => _buildInputArea()),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    if (availableOptions.isEmpty &&
        !controller.isLastQuestion.value &&
        !controller.isLoadingQuestions.value) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Menunggu pertanyaan...',
          style: TextStyle(color: Colors.grey[500]),
        ),
      );
    }

    if (controller.isLastQuestion.value) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Skrining selesai. Silakan lihat hasil.',
          style: TextStyle(color: Colors.green[700]),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: availableOptions.map((option) {
              return ChoiceChip(
                label: Text(option.answer),
                selected: false,
                onSelected: (selected) {
                  if (selected) {
                    _handleAnswer(option);
                  }
                },
                backgroundColor: Colors.grey[200],
                selectedColor: const Color(0xFF4A90E2),
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Silahkan pilih jawaban',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Icon(Icons.send, color: Colors.grey[400]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
