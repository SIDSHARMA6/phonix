import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models.dart';
import 'database.dart';
import 'scraper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await QuizDatabase.initialize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF1A237E),
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phoenix Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(primary: Color(0xFF1A237E)),
      ),
      home: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  QuestionData? currentQuestion;
  List<String> questionPath = []; // Track the path of questions taken
  bool isLoading = true;
  bool isScrapingData = false;
  String scrapingStatus = '';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // User info form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));
    _initializeQuiz();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _initializeQuiz() async {
    setState(() => isLoading = true);

    // Check if we have questions in local storage
    if (QuizDatabase.hasQuestions()) {
      _loadFirstQuestion();
    } else {
      // Try to scrape questions from the website
      await _scrapeAndLoadQuestions();
    }

    setState(() => isLoading = false);
    _fadeController.forward();
  }

  Future<void> _scrapeAndLoadQuestions() async {
    setState(() {
      isScrapingData = true;
      scrapingStatus = 'Connecting to Phoenix website...';
    });

    try {
      List<QuestionData> questions = await PhoenixScraper.scrapeAllQuestions();

      if (questions.isEmpty) {
        throw Exception('No questions could be scraped from Phoenix website');
      }

      await QuizDatabase.saveQuestions(questions);
      _loadFirstQuestion();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Successfully loaded ${questions.length} questions from Phoenix website'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load questions: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _scrapeAndLoadQuestions,
            ),
          ),
        );
      }
    }

    setState(() {
      isScrapingData = false;
      scrapingStatus = '';
    });
  }

  void _loadFirstQuestion() {
    currentQuestion = QuizDatabase.getFirstQuestion();
    if (currentQuestion != null) {
      questionPath = [currentQuestion!.id];
    }
  }

  void _selectAnswer(int optionIndex) async {
    if (currentQuestion == null) return;

    // Save the answer
    await QuizDatabase.saveAnswer(currentQuestion!.id, optionIndex);

    // Check if this is the 5th question (after 5 questions answered)
    if (QuizDatabase.getAnsweredQuestionsCount() == 5) {
      _showUserInfoForm();
      return;
    }

    // Get next question based on selected option
    QuestionData? nextQuestion =
        QuizDatabase.getNextQuestion(currentQuestion!.id, optionIndex);

    if (nextQuestion != null) {
      await _fadeController.reverse();
      setState(() {
        currentQuestion = nextQuestion;
        questionPath.add(nextQuestion.id);
      });
      _fadeController.forward();
    } else {
      // If no specific next question, try to find any unanswered question
      List<QuestionData> allQuestions = QuizDatabase.getAllQuestions();
      QuestionData? unansweredQuestion;

      for (QuestionData question in allQuestions) {
        if (QuizDatabase.getAnswer(question.id) == null &&
            !questionPath.contains(question.id)) {
          unansweredQuestion = question;
          break;
        }
      }

      if (unansweredQuestion != null) {
        await _fadeController.reverse();
        setState(() {
          currentQuestion = unansweredQuestion;
          questionPath.add(unansweredQuestion!.id);
        });
        _fadeController.forward();
      } else {
        _showQuizCompleted();
      }
    }
  }

  void _goToPreviousQuestion() async {
    if (questionPath.length <= 1) return;

    await _fadeController.reverse();

    // Remove current question from path
    questionPath.removeLast();

    // Load previous question
    String previousQuestionId = questionPath.last;
    setState(() {
      currentQuestion = QuizDatabase.getQuestion(previousQuestionId);
    });

    _fadeController.forward();
  }

  void _showUserInfoForm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Please provide your information',
            style: TextStyle(
              color: Color(0xFF1A237E),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 25)),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Select Date of Birth',
                          style: TextStyle(
                            color: _selectedDate != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _validateAndSaveUserInfo(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E)),
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSaveUserInfo() async {
    // Validate all fields
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Calculate age
    final now = DateTime.now();
    int age = now.year - _selectedDate!.year;
    if (now.month < _selectedDate!.month ||
        (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
      age--;
    }

    // Check if user is 18+
    if (age < 18) {
      if (mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Sorry',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'You must be 18 years or older to continue with this questionnaire.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Reset the quiz
                  _resetQuiz();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Save user profile
    UserProfile profile = UserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      dateOfBirth: _selectedDate!,
      mobileNumber: _mobileController.text.trim(),
      registrationDate: DateTime.now(),
    );

    await QuizDatabase.saveUserProfile(profile);

    if (mounted) {
      Navigator.pop(context);
      // Continue with next question
      _continueToNextQuestion();
    }
  }

  void _continueToNextQuestion() async {
    // Get next question
    List<QuestionData> allQuestions = QuizDatabase.getAllQuestions();
    QuestionData? unansweredQuestion;

    for (QuestionData question in allQuestions) {
      if (QuizDatabase.getAnswer(question.id) == null &&
          !questionPath.contains(question.id)) {
        unansweredQuestion = question;
        break;
      }
    }

    if (unansweredQuestion != null) {
      await _fadeController.reverse();
      setState(() {
        currentQuestion = unansweredQuestion;
        questionPath.add(unansweredQuestion!.id);
      });
      _fadeController.forward();
    } else {
      _showQuizCompleted();
    }
  }

  void _resetQuiz() async {
    await QuizDatabase.clearAnswers();
    await QuizDatabase.clearUserProfile();
    _nameController.clear();
    _emailController.clear();
    _mobileController.clear();
    _selectedDate = null;
    _loadFirstQuestion();
    setState(() {
      questionPath.clear();
    });
    _fadeController.reset();
    _fadeController.forward();
  }

  void _showQuizCompleted() async {
    int answeredCount = QuizDatabase.getAnsweredQuestionsCount();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Quiz Completed!',
          style:
              TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'You have completed the questionnaire with $answeredCount answers.'),
            const SizedBox(height: 16),
            const Text(
              'Your responses have been saved locally.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('View Results',
                style: TextStyle(color: Color(0xFF1A237E))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await QuizDatabase.clearAnswers();
              _loadFirstQuestion();
              setState(() {});
              _fadeController.reset();
              _fadeController.forward();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E)),
            child: const Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }

  void _refreshQuestions() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refresh Questions'),
        content: const Text(
            'This will download the latest questions from the Phoenix website. Continue?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E)),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await QuizDatabase.clearAllData();
      await _scrapeAndLoadQuestions();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isLoading || isScrapingData) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF1A237E)),
              const SizedBox(height: 16),
              Text(
                isScrapingData ? scrapingStatus : 'Loading quiz...',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (isScrapingData) ...[
                const SizedBox(height: 8),
                const Text(
                  'This may take a few moments...',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (currentQuestion == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'No questions available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Questions need to be loaded from Phoenix website',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isScrapingData ? null : _refreshQuestions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: isScrapingData
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(isScrapingData ? 'Loading...' : 'Load Questions'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header with refresh button
          Container(
            width: double.infinity,
            height: isMobile ? 70 : 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1A237E),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'PHOENIX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: isMobile ? 2.0 : 3.0,
                      ),
                    ),
                  ),
                ),
                if (!isScrapingData)
                  IconButton(
                    onPressed: _refreshQuestions,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    tooltip: 'Refresh Questions',
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        (isMobile ? 70 : 80)),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                        maxWidth: isMobile ? screenWidth - 32 : 800),
                    padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              // Question
                              Container(
                                margin:
                                    EdgeInsets.only(bottom: isMobile ? 32 : 48),
                                child: Text(
                                  currentQuestion!.text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isMobile ? 20 : 24,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF212121),
                                    height: 1.4,
                                  ),
                                ),
                              ),

                              // Options
                              ...currentQuestion!.options
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final option = entry.value;
                                final savedAnswer =
                                    QuizDatabase.getAnswer(currentQuestion!.id);
                                final isSelected =
                                    savedAnswer?.selectedOptionIndex == index;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: _OptionButton(
                                    text: option.text,
                                    isSelected: isSelected,
                                    onTap: () => _selectAnswer(index),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        SizedBox(height: isMobile ? 24 : 40),

                        // Navigation
                        if (questionPath.length > 1)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: _goToPreviousQuestion,
                              child: Text(
                                'Previous',
                                style: TextStyle(
                                  fontSize: isMobile ? 15 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionButton(
      {required this.text, required this.isSelected, required this.onTap});

  @override
  State<_OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<_OptionButton>
    with TickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                constraints: BoxConstraints(minHeight: isMobile ? 52 : 56),
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: isMobile ? 14 : 16),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? const Color(0xFF1A237E).withAlpha(25)
                      : (isHovered ? const Color(0xFFF8F8F8) : Colors.white),
                  border: Border.all(
                    color: widget.isSelected
                        ? const Color(0xFF1A237E)
                        : (isHovered
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFFE8E8E8)),
                    width: widget.isSelected ? 2.0 : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    if (isHovered || widget.isSelected)
                      BoxShadow(
                        color: Colors.black.withAlpha(12),
                        blurRadius: widget.isSelected ? 8 : 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: isMobile ? 15 : 16,
                          fontWeight: widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: widget.isSelected
                              ? const Color(0xFF1A237E)
                              : const Color(0xFF212121),
                        ),
                      ),
                    ),
                    Icon(
                      widget.isSelected
                          ? Icons.check_circle
                          : Icons.chevron_right,
                      color: widget.isSelected
                          ? const Color(0xFF1A237E)
                          : const Color(0xFF9E9E9E),
                      size: isMobile ? 18 : 20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
