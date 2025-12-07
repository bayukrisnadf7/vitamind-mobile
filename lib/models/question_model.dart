class QuestionModel {
  final int id;
  final String text;
  final String category;
  final String? expertRecommendation;
  final List<AnswerOption> options;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.category,
    this.expertRecommendation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'],
      category: json['category'],
      expertRecommendation: json['expert_recommendation'],
      options: (json['options'] as List)
          .map((i) => AnswerOption.fromJson(i))
          .toList(),
    );
  }
}

class AnswerOption {
  final String answer;
  final int nextQuestionId;
  final int value;
  final String? education;

  AnswerOption({
    required this.answer,
    required this.nextQuestionId,
    required this.value,
    this.education,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      answer: json['answer'],
      nextQuestionId: json['next_question_id'],
      value: json['value'],
      education: json['education'],
    );
  }
}
