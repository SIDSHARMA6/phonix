import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import 'models.dart';
import 'phoenix_questions.dart';

class PhoenixScraper {
  static const String baseUrl = 'https://patient.phoenix.ca';
  static const String startUrl =
      '$baseUrl/onboarding/ed/question-ed-problem-frequency';

  static Future<List<QuestionData>> scrapeAllQuestions() async {
    // First, try to scrape from the actual website
    try {
      List<QuestionData> scrapedQuestions = await _attemptWebScraping();
      if (scrapedQuestions.isNotEmpty) {
        return scrapedQuestions;
      }
    } catch (e) {
      // If scraping fails, continue to use the manual questions
    }

    // Use the manually created Phoenix questions structure
    // This is based on the actual Phoenix ED assessment questionnaire
    List<QuestionData> questions = PhoenixQuestions.getAllQuestions();

    if (questions.isEmpty) {
      throw Exception('No questions available');
    }

    return questions;
  }

  static Future<List<QuestionData>> _attemptWebScraping() async {
    List<QuestionData> questions = [];

    try {
      // Try to access the Phoenix website
      final response = await http.get(
        Uri.parse(startUrl),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.9',
          'Accept-Encoding': 'gzip, deflate, br',
          'Connection': 'keep-alive',
          'Upgrade-Insecure-Requests': '1',
          'Sec-Fetch-Dest': 'document',
          'Sec-Fetch-Mode': 'navigate',
          'Sec-Fetch-Site': 'none',
          'Sec-Fetch-User': '?1',
          'Cache-Control': 'max-age=0',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Document document = html_parser.parse(response.body);

        // Try to extract the first question
        String? questionText = _findQuestionText(document);
        List<AnswerOption> options = _extractAnswerOptions(document);

        if (questionText != null && options.isNotEmpty) {
          questions.add(QuestionData(
            id: 'scraped-question-1',
            text: questionText,
            options: options,
          ));

          // If we successfully scraped one question, we could try to discover more
          // But for now, we'll fall back to our manual questions
        }
      }
    } catch (e) {
      // Scraping failed, will use manual questions
    }

    return questions;
  }

  static String? _findQuestionText(Document document) {
    // Try various selectors that might contain the question
    List<String> selectors = [
      'h1',
      'h2',
      'h3',
      '.question',
      '.question-text',
      '.question-title',
      '[data-testid*="question"]',
      '[data-cy*="question"]',
      'main h1',
      'main h2',
      'main p',
      '.content h1',
      '.content h2',
      '.content p',
      '.form-question',
      '.quiz-question',
    ];

    for (String selector in selectors) {
      Element? element = document.querySelector(selector);
      if (element != null) {
        String text = element.text.trim();
        if (_looksLikeQuestion(text)) {
          return text;
        }
      }
    }

    // Try to find text that looks like a question in the entire document
    String bodyText = document.body?.text ?? '';
    List<String> sentences = bodyText.split(RegExp(r'[.!?]'));

    for (String sentence in sentences) {
      String trimmed = sentence.trim();
      if (_looksLikeQuestion(trimmed)) {
        return '$trimmed?';
      }
    }

    return null;
  }

  static bool _looksLikeQuestion(String text) {
    if (text.length < 20 || text.length > 500) return false;

    // Check for question indicators
    if (text.contains('?')) return true;

    // Check for common question starters
    List<String> questionStarters = [
      'do you',
      'have you',
      'how often',
      'how would',
      'when do',
      'what is',
      'which of',
      'are you',
      'can you',
      'did you',
      'how many',
      'how long',
      'where do',
      'why do',
      'who is'
    ];

    String lowerText = text.toLowerCase();
    for (String starter in questionStarters) {
      if (lowerText.startsWith(starter)) {
        return true;
      }
    }

    return false;
  }

  static List<AnswerOption> _extractAnswerOptions(Document document) {
    List<AnswerOption> options = [];

    // Try various selectors for answer options
    List<String> selectors = [
      'button[type="button"]',
      '.option',
      '.answer-option',
      '.choice',
      '[data-testid*="option"]',
      '[data-cy*="option"]',
      'input[type="radio"] + label',
      '.form-option',
      '.quiz-option',
      'li',
      'a[href*="answer"]',
    ];

    for (String selector in selectors) {
      List<Element> elements = document.querySelectorAll(selector);

      for (Element element in elements) {
        String text = element.text.trim();

        if (text.isNotEmpty &&
            text.length > 2 &&
            text.length < 200 &&
            !_isNavigationButton(text) &&
            _looksLikeAnswerOption(text)) {
          options.add(AnswerOption(
            text: text,
            nextQuestionId: null,
          ));
        }
      }

      if (options.isNotEmpty && options.length >= 2) {
        break;
      }
    }

    return options;
  }

  static bool _isNavigationButton(String text) {
    List<String> navButtons = [
      'next',
      'previous',
      'back',
      'continue',
      'submit',
      'skip',
      'home',
      'menu',
      'close',
      'cancel',
      'save',
      'login',
      'signup',
      'start',
      'begin',
      'finish',
      'complete'
    ];

    String lowerText = text.toLowerCase();
    return navButtons.any((nav) => lowerText.contains(nav));
  }

  static bool _looksLikeAnswerOption(String text) {
    if (text.length < 3 || text.length > 200) return false;

    // Common answer patterns for medical questionnaires
    List<String> answerPatterns = [
      'yes',
      'no',
      'never',
      'always',
      'sometimes',
      'often',
      'rarely',
      'very',
      'extremely',
      'moderately',
      'slightly',
      'not at all',
      'every time',
      'most times',
      'half the time',
      'few times',
      'less than',
      'more than',
      'about',
      'approximately',
      'daily',
      'weekly',
      'monthly',
      'yearly',
      'mild',
      'moderate',
      'severe',
      'none',
      'excellent',
      'good',
      'fair',
      'poor',
      'high',
      'medium',
      'low'
    ];

    String lowerText = text.toLowerCase();
    return answerPatterns.any((pattern) => lowerText.contains(pattern));
  }
}
