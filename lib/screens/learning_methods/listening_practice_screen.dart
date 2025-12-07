import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/json_loader.dart';
import '../../models/word_item.dart';

class ListeningPracticeScreen extends StatefulWidget {
  final String categoryName;

  const ListeningPracticeScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<ListeningPracticeScreen> createState() => _ListeningPracticeScreenState();
}

class _ListeningPracticeScreenState extends State<ListeningPracticeScreen> {
  final JsonLoader _jsonLoader = JsonLoader();
  final FlutterTts _flutterTts = FlutterTts();
  List<WordItem> _words = [];
  bool _isLoading = true;
  String? _error;

  int _currentIndex = 0;
  List<String> _currentOptions = [];
  bool _hasAnswered = false;
  String? _selectedAnswer;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _loadWords();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("de-DE");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
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

      _startQuestion();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _startQuestion() {
    if (_currentIndex >= _words.length) {
      _showCompletionDialog();
      return;
    }

    final currentWord = _words[_currentIndex];

    // Generate options: 1 correct + 3 wrong from other words
    final correctAnswer = currentWord.tr;
    final wrongWords = _words
        .where((word) => word != currentWord)
        .take(3)
        .map((word) => word.tr)
        .toList();

    _currentOptions = [correctAnswer, ...wrongWords];
    _currentOptions.shuffle();

    setState(() {
      _hasAnswered = false;
      _selectedAnswer = null;
      _showResult = false;
    });

    // Auto-play the German word after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _speakWord(currentWord.de);
    });
  }

  Future<void> _speakWord(String word) async {
    await _flutterTts.speak(word);
  }

  void _answerQuestion(String selectedAnswer) {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      _selectedAnswer = selectedAnswer;
      _showResult = true;
    });

    // Delay before moving to next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _startQuestion();
    } else {
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

  Color _getOptionColor(String option) {
    if (!_showResult) return Colors.white.withOpacity(0.1);

    final currentWord = _words[_currentIndex];
    final correctAnswer = currentWord.tr;

    if (option == correctAnswer) {
      return Colors.green.withOpacity(0.8);
    }

    if (_selectedAnswer == option && option != correctAnswer) {
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
                  'Listening Practice - ${widget.categoryName}',
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

          // Speaker icon and instruction
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: IconButton(
                  onPressed: () => _speakWord(currentWord.de),
                  icon: const Icon(
                    Icons.volume_up,
                    color: Colors.blue,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Dinle ve doğru cevabı seç',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Almanca kelimeyi dinlemek için hoparlöre dokun',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: _currentOptions.length,
              itemBuilder: (context, index) {
                final option = _currentOptions[index];
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
                      boxShadow: _showResult && option == _words[_currentIndex].tr
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
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
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
                              if (_showResult && option == _words[_currentIndex].tr)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              if (_showResult && _selectedAnswer == option && option != _words[_currentIndex].tr)
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

          const SizedBox(height: 20),

          // Repeat button (only show before answering)
          if (!_hasAnswered)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _speakWord(currentWord.de),
                icon: const Icon(Icons.replay, color: Colors.white),
                label: const Text(
                  'Tekrar Dinle',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}