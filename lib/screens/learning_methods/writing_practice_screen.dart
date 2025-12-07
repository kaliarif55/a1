import 'package:flutter/material.dart';
import '../../services/json_loader.dart';
import '../../models/word_item.dart';

class WritingPracticeScreen extends StatefulWidget {
  final String categoryName;

  const WritingPracticeScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<WritingPracticeScreen> createState() => _WritingPracticeScreenState();
}

class _WritingPracticeScreenState extends State<WritingPracticeScreen> {
  final JsonLoader _jsonLoader = JsonLoader();
  List<WordItem> _words = [];
  bool _isLoading = true;
  String? _error;

  int _currentIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  bool _hasAnswered = false;
  bool _isCorrect = false;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final words = await _jsonLoader.loadWords(widget.categoryName);

      if (words.isEmpty) {
        throw Exception('Bu kategoride kelime bulunamadı');
      }

      setState(() {
        _words = words;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _checkAnswer() {
    if (_hasAnswered) return;

    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = _words[_currentIndex].tr.toLowerCase();

    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      _hasAnswered = true;
      _isCorrect = isCorrect;
      _showFeedback = true;
    });

    // Auto-advance after delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
        _answerController.clear();
        _hasAnswered = false;
        _showFeedback = false;
      });
    } else {
      // Quiz completed
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1F26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Tebrikler!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '${widget.categoryName} kategorisini tamamladınız!',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to category selection
            },
            child: const Text(
              'Tamam',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
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
              _error!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadWords,
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

    if (_words.isEmpty) {
      return const Center(
        child: Text(
          'Kelime bulunamadı',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    final currentWord = _words[_currentIndex];

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
                  'Writing Practice - ${widget.categoryName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                  '${_currentIndex + 1}/${_words.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // German word
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              currentWord.de,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
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

          // Answer input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _showFeedback
                    ? (_isCorrect ? Colors.green : Colors.red).withOpacity(0.5)
                    : Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: TextField(
              controller: _answerController,
              enabled: !_hasAnswered,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: 'Türkçe karşılığını yazın...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 18,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _checkAnswer(),
            ),
          ),

          const SizedBox(height: 20),

          // Feedback
          if (_showFeedback)
            AnimatedOpacity(
              opacity: _showFeedback ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: _isCorrect
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCorrect ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isCorrect ? Icons.check_circle : Icons.cancel,
                      color: _isCorrect ? Colors.green : Colors.red,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCorrect
                          ? 'Doğru! Cevap: ${currentWord.tr}'
                          : 'Yanlış. Doğru cevap: ${currentWord.tr}',
                      style: TextStyle(
                        color: _isCorrect ? Colors.green : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 40),

          // Check answer button
          if (!_hasAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _answerController.text.trim().isNotEmpty ? _checkAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Cevabı Kontrol Et',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Progress indicator
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentIndex + (_hasAnswered ? 1 : 0)) / _words.length,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}