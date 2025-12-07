import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/word.dart';
import '../widgets/word_tile.dart';
import 'quiz_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryKey;
  final String title;

  static const routeName = '/category-detail';

  const CategoryDetailScreen({
    Key? key,
    required this.categoryKey,
    required this.title,
  }) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<Word> _words = [];
  bool _isLoading = true;
  String? _error;

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

      final path = 'assets/categories/${widget.categoryKey}.json';
      final jsonString = await rootBundle.loadString(path);
      final jsonData = json.decode(jsonString) as List<dynamic>;

      final words = jsonData.map((item) => Word.fromJson(item)).toList();

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

  void _startQuiz(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/quiz-with-params',
      arguments: {
        'title': '${widget.title} Quiz',
        'jsonPath': 'assets/categories/${widget.categoryKey}.json',
      },
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
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.quiz,
                        color: Colors.white,
                      ),
                      onPressed: () => _startQuiz(context),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _words.length,
      itemBuilder: (context, index) {
        final word = _words[index];
        return WordTile(
          word: word,
          onTap: () {
            // Future: implement flashcard/quiz functionality
          },
        );
      },
    );
  }
}
