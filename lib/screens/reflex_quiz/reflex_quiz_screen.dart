import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../services/json_loader.dart';
import 'reflex_quiz_result.dart';

class ReflexQuizScreen extends StatefulWidget {
  const ReflexQuizScreen({super.key, required this.categoryName});

  static const routeName = '/reflex-quiz';
  final String categoryName;

  @override
  State<ReflexQuizScreen> createState() => _ReflexQuizScreenState();
}

class _ReflexQuizScreenState extends State<ReflexQuizScreen> with TickerProviderStateMixin {
  final _random = Random();
  final int _timePerQuestion = 4;

  List<Map<String, String>> _questions = [];
  List<String> _choices = [];
  int _currentIndex = 0;
  int _score = 0;
  int _remainingSeconds = 4;
  bool _locked = false;
  String? _selectedAnswer;
  Color? _flashColor;
  Timer? _timer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _loading = true;
      });
      final data = await JsonLoader.loadCategory(widget.categoryName);
      if (!mounted) return;
      setState(() {
        _questions = data;
        _loading = false;
      });
      if (data.isNotEmpty) {
        _startQuestion();
      } else {
        print('Warning: No data loaded for category: ${widget.categoryName}');
      }
    } catch (e) {
      if (!mounted) return;
      print('Error loading data for ${widget.categoryName}: $e');
      setState(() {
        _questions = [];
        _loading = false;
      });
    }
  }

  void _startQuestion() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _timePerQuestion;
      _locked = false;
      _selectedAnswer = null;
      _flashColor = null;
      _choices = _buildChoices();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        _handleTimeout();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _handleTimeout() {
    _timer?.cancel();
    _moveNext();
  }

  void _selectAnswer(String answer) {
    if (_locked) return;
    final correct = _questions[_currentIndex]['tr'] ?? '';
    final isCorrect = answer == correct;
    if (isCorrect) {
      _score++;
    }
    setState(() {
      _locked = true;
      _selectedAnswer = answer;
      _flashColor = isCorrect ? Colors.green : Colors.red;
    });
    _timer?.cancel();
    Future.delayed(const Duration(milliseconds: 650), _moveNext);
  }

  void _moveNext() {
    if (!mounted) return;
    if (_currentIndex + 1 >= _questions.length) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, animation, __) => FadeTransition(
            opacity: animation,
            child: ReflexQuizResultScreen(
              score: _score,
              total: _questions.length,
              categoryName: widget.categoryName,
            ),
          ),
        ),
      );
      return;
    }
    setState(() => _currentIndex++);
    _startQuestion();
  }

  List<String> _buildChoices() {
    final correct = _questions[_currentIndex]['tr'] ?? '';
    final pool = _questions
        .map((e) => e['tr'] ?? '')
        .where((item) => item.isNotEmpty && item != correct)
        .toList();
    pool.shuffle(_random);
    final options = <String>[correct];
    for (final option in pool) {
      if (options.length == 4) break;
      if (!options.contains(option)) options.add(option);
    }
    while (options.length < 4) {
      options.add(pool.isNotEmpty ? pool[_random.nextInt(pool.length)] : correct);
    }
    options.shuffle(_random);
    return options;
  }

  Color _timerColor() {
    if (_remainingSeconds > 2) return Colors.greenAccent;
    if (_remainingSeconds > 1) return Colors.yellowAccent;
    return Colors.redAccent;
  }

  Widget _buildAnswerButton(String answer) {
    final correct = _questions[_currentIndex]['tr'] ?? '';
    final isSelected = _selectedAnswer == answer;
    final isCorrect = answer == correct;
    final Color baseColor = isSelected
        ? (isCorrect ? Colors.green : Colors.redAccent)
        : Colors.white.withOpacity(0.08);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          width: 1.2,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: baseColor.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _locked ? null : () => _selectAnswer(answer),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Center(
              child: Text(
                answer,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 96,
          width: 96,
          child: CircularProgressIndicator(
            value: _remainingSeconds / _timePerQuestion,
            strokeWidth: 8,
            valueColor: AlwaysStoppedAnimation<Color>(_timerColor()),
            backgroundColor: Colors.white.withOpacity(0.1),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            '$_remainingSeconds',
            key: ValueKey<int>(_remainingSeconds),
            style: TextStyle(
              color: _timerColor(),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _questions.isEmpty
                  ? _EmptyState(categoryName: widget.categoryName)
                  : Stack(
                      children: [
                        if (_flashColor != null)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            color: _flashColor!.withOpacity(0.25),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  ),
                                  Text(
                                    widget.categoryName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 48),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildCountdown(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Soru ${_currentIndex + 1} / ${_questions.length}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Puan: $_score',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 350),
                                      transitionBuilder: (child, animation) => FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(
                                          scale: Tween<double>(begin: 0.96, end: 1).animate(animation),
                                          child: child,
                                        ),
                                      ),
                                      child: Container(
                                        key: ValueKey<int>(_currentIndex),
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.15),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.25),
                                              blurRadius: 18,
                                              offset: const Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _questions[_currentIndex]['de'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Almanca → Turkce',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.7),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Expanded(
                                      child: GridView.builder(
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 2.8,
                                        ),
                                        itemCount: _choices.length,
                                        itemBuilder: (context, index) => _buildAnswerButton(_choices[index]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.white70, size: 48),
          const SizedBox(height: 12),
          Text(
            '$categoryName icin soru bulunamadi',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Geri don'),
          ),
        ],
      ),
    );
  }
}
