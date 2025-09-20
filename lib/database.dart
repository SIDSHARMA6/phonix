import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

class QuizDatabase {
  static const String questionsBoxName = 'questions';
  static const String answersBoxName = 'user_answers';
  static const String userProfileBoxName = 'user_profile';

  static late Box<QuestionData> _questionsBox;
  static late Box<UserAnswer> _answersBox;
  static late Box<UserProfile> _userProfileBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(QuestionDataAdapter());
    Hive.registerAdapter(AnswerOptionAdapter());
    Hive.registerAdapter(UserAnswerAdapter());
    Hive.registerAdapter(UserProfileAdapter());

    // Open boxes
    _questionsBox = await Hive.openBox<QuestionData>(questionsBoxName);
    _answersBox = await Hive.openBox<UserAnswer>(answersBoxName);
    _userProfileBox = await Hive.openBox<UserProfile>(userProfileBoxName);
  }

  // Questions management
  static Future<void> saveQuestions(List<QuestionData> questions) async {
    await _questionsBox.clear();
    for (var question in questions) {
      await _questionsBox.put(question.id, question);
    }
  }

  static List<QuestionData> getAllQuestions() {
    return _questionsBox.values.toList();
  }

  static QuestionData? getQuestion(String id) {
    return _questionsBox.get(id);
  }

  static QuestionData? getFirstQuestion() {
    // Look for the specific first question ID
    QuestionData? firstQuestion = getQuestion('ed-problem-frequency');
    if (firstQuestion != null) {
      return firstQuestion;
    }

    // Fallback: return first question in the list
    return _questionsBox.values.isNotEmpty ? _questionsBox.values.first : null;
  }

  static QuestionData? getNextQuestion(
      String currentQuestionId, int selectedOptionIndex) {
    QuestionData? currentQuestion = getQuestion(currentQuestionId);
    if (currentQuestion == null ||
        selectedOptionIndex >= currentQuestion.options.length) {
      return null;
    }

    AnswerOption selectedOption = currentQuestion.options[selectedOptionIndex];
    if (selectedOption.nextQuestionId != null) {
      return getQuestion(selectedOption.nextQuestionId!);
    }

    return null;
  }

  static bool hasQuestions() {
    return _questionsBox.isNotEmpty;
  }

  static int getQuestionsCount() {
    return _questionsBox.length;
  }

  static List<String> getAllQuestionIds() {
    return _questionsBox.keys.cast<String>().toList();
  }

  // User answers management
  static Future<void> saveAnswer(
      String questionId, int selectedOptionIndex) async {
    UserAnswer answer = UserAnswer(
      questionId: questionId,
      selectedOptionIndex: selectedOptionIndex,
      timestamp: DateTime.now(),
    );
    await _answersBox.put(questionId, answer);
  }

  static UserAnswer? getAnswer(String questionId) {
    return _answersBox.get(questionId);
  }

  static List<UserAnswer> getAllAnswers() {
    return _answersBox.values.toList();
  }

  static Future<void> clearAnswers() async {
    await _answersBox.clear();
  }

  static int getAnsweredQuestionsCount() {
    return _answersBox.length;
  }

  // Data management
  static Future<void> clearAllData() async {
    await _questionsBox.clear();
    await _answersBox.clear();
  }

  // User profile management
  static Future<void> saveUserProfile(UserProfile profile) async {
    await _userProfileBox.put('current_user', profile);
  }

  static UserProfile? getUserProfile() {
    return _userProfileBox.get('current_user');
  }

  static bool hasUserProfile() {
    return _userProfileBox.containsKey('current_user');
  }

  static Future<void> clearUserProfile() async {
    await _userProfileBox.delete('current_user');
  }

  static Future<void> close() async {
    await _questionsBox.close();
    await _answersBox.close();
    await _userProfileBox.close();
  }
}
