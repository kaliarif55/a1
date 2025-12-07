import 'package:flutter/material.dart';

import 'reflex_quiz_screen.dart';

class ReflexQuizResultScreen extends StatelessWidget {
  const ReflexQuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.categoryName,
  });

  static const routeName = '/reflex-quiz/result';
  final int score;
  final int total;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : (score / total * 100).round();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 72),
                const SizedBox(height: 16),
                Text(
                  'Harika Is!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$score / $total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '%$percent basari',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        categoryName,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            ReflexQuizScreen.routeName,
                            arguments: {'categoryName': categoryName},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Yeniden Basla',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 1.4),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          'Yontemler',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
