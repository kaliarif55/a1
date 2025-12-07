import 'package:flutter/material.dart';
import 'home_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final String title;
  final int correct;
  final int total;

  const QuizResultScreen({
    Key? key,
    required this.title,
    required this.correct,
    required this.total,
  }) : super(key: key);

  static const routeName = '/quiz-result';

  double get _percentage => total > 0 ? (correct / total) * 100 : 0;

  String get _performanceMessage {
    final percentage = _percentage;
    if (percentage >= 90) return 'Mükemmel!';
    if (percentage >= 80) return 'Çok iyi!';
    if (percentage >= 70) return 'İyi!';
    if (percentage >= 60) return 'Fena değil!';
    return 'Daha fazla çalışmalısın!';
  }

  Color get _performanceColor {
    final percentage = _percentage;
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
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
          child: Padding(
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
                        title,
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
                  ],
                ),

                const SizedBox(height: 40),

                // Trophy icon
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _performanceColor.withOpacity(0.8),
                        _performanceColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _performanceColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 80,
                  ),
                ),

                const SizedBox(height: 32),

                // Quiz completed text
                Text(
                  'Quiz Tamamlandı!',
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

                const SizedBox(height: 16),

                // Performance message
                Text(
                  _performanceMessage,
                  style: TextStyle(
                    color: _performanceColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Score display
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
                  child: Column(
                    children: [
                      Text(
                        'Sonuç',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$correct / $total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: _performanceColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Progress bar
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _performanceColor.withOpacity(0.8),
                            _performanceColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Go back to quiz
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1C1F26),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Tekrar Dene',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routeName,
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Ana Menü',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
