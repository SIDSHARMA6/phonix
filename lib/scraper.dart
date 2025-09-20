import 'models.dart';
import 'phoenix_questions.dart';

class PhoenixScraper {
  static const String baseUrl = 'https://patient.phoenix.ca';
  static const String startUrl =
      '$baseUrl/onboarding/ed/question-ed-problem-frequency';

  static Future<List<QuestionData>> scrapeAllQuestions() async {
    // For web deployment, directly use the Phoenix questions structure
    // This ensures fast loading without network dependencies
    List<QuestionData> questions = PhoenixQuestions.getAllQuestions();

    if (questions.isEmpty) {
      throw Exception('No questions available');
    }

    // Add a small delay to simulate loading for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    return questions;
  }
}
