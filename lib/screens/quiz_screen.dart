import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/question.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final String jsonPath;

  const QuizScreen({
    Key? key,
    required this.title,
    required this.jsonPath,
  }) : super(key: key);

  static const routeName = '/quiz';

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  List<Question> _questions = [];
  bool _isLoading = true;
  String? _error;

  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;
  String? _selectedAnswer;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final questions = await _quizService.loadQuestions(widget.jsonPath);

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _answerQuestion(String selectedAnswer) {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      _selectedAnswer = selectedAnswer;
      _showResult = true;

      final currentQuestion = _questions[_currentQuestionIndex];
      if (selectedAnswer == currentQuestion.correctAnswer) {
        _score++;
      }
    });

    // Delay before moving to next question
    Future.delayed(const Duration(milliseconds: 600), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _hasAnswered = false;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      // Quiz completed, navigate to result screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            title: widget.title,
            correct: _score,
            total: _questions.length,
          ),
        ),
      );
    }
  }

  Color _getOptionColor(String option) {
    if (!_showResult) return Colors.white.withOpacity(0.1);

    if (option == _questions[_currentQuestionIndex].correctAnswer) {
      return Colors.green.withOpacity(0.8);
    }

    if (_selectedAnswer == option && option != _questions[_currentQuestionIndex].correctAnswer) {
      return Colors.red.withOpacity(0.8);
    }

    return Colors.white.withOpacity(0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1C1F26),
              Color(0xFF2A2F3A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Veri yüklenemedi',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Lütfen tekrar deneyin',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadQuestions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1C1F26),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (_questions.isEmpty) {
      return const Center(
        child: Text(
          'Soru bulunamadı',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentQuestionIndex + 1) / _questions.length,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Score display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Doğru: $_score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Question
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              currentQuestion.questionText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion.options.length,
              itemBuilder: (context, index) {
                final option = currentQuestion.options[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _getOptionColor(option),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: _showResult && option == _questions[_currentQuestionIndex].correctAnswer
                          ? [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _hasAnswered ? null : () => _answerQuestion(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (_showResult && option == _questions[_currentQuestionIndex].correctAnswer)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              if (_showResult && _selectedAnswer == option && option != _questions[_currentQuestionIndex].correctAnswer)
                                const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
