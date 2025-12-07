import 'package:flutter/material.dart';
import '../../services/json_loader.dart';
import '../../models/word_item.dart';

class FlashcardsScreen extends StatefulWidget {
  final String categoryName;

  const FlashcardsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final JsonLoader _jsonLoader = JsonLoader();
  List<WordItem> _words = [];
  bool _isLoading = true;
  String? _error;

  int _currentIndex = 0;
  bool _showMeaning = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
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

  void _nextWord() {
    if (_words.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _words.length;
        _showMeaning = false;
      });
    }
  }

  void _previousWord() {
    if (_words.isNotEmpty) {
      setState(() {
        _currentIndex = _currentIndex > 0 ? _currentIndex - 1 : _words.length - 1;
        _showMeaning = false;
      });
    }
  }

  void _shuffleWords() {
    if (_words.isNotEmpty) {
      setState(() {
        _words.shuffle();
        _currentIndex = 0;
        _showMeaning = false;
      });
    }
  }

  void _finish() {
    Navigator.of(context).pop();
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
                onPressed: _finish,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Flashcards - ${widget.categoryName}',
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

          // Flashcard
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showMeaning = !_showMeaning;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // German word
                    Text(
                      currentWord.de,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
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

                    const SizedBox(height: 24),

                    // Show meaning button or Turkish word
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _showMeaning
                          ? Column(
                              key: const ValueKey('meaning'),
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    currentWord.tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              key: const ValueKey('button'),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Anlamını Göster',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.skip_previous,
                label: 'Önceki',
                onPressed: _previousWord,
                color: Colors.blue,
              ),
              _buildControlButton(
                icon: Icons.shuffle,
                label: 'Karıştır',
                onPressed: _shuffleWords,
                color: Colors.purple,
              ),
              _buildControlButton(
                icon: Icons.skip_next,
                label: 'Sonraki',
                onPressed: _nextWord,
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Finish button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _finish,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Bitir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: color),
            iconSize: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}